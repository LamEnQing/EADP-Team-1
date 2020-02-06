﻿using MyCircles.DAL;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyCircles.Home
{

    public partial class Post : System.Web.UI.Page
    {
        public BLL.User currentUser;


        protected void Page_Load(object sender, EventArgs e)
        {
            RedirectValidator.isUser();
            currentUser = (BLL.User)Session["currentUser"];

            this.Title = "Home";
            CircleDAO.AddCircle("gym");
            rptUserPosts.DataSource = PostDAO.GetPostsByCircle("gym");
            rptUserPosts.DataBind();
        }

        protected void ImageMap1_Click(object sender, ImageMapEventArgs e)
        {

        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {

        }

        protected void btn6_Click(object sender, EventArgs e)
        {
            Response.Redirect("PeopleNearby.aspx");
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            try
            {
                var newPost = new BLL.Post();
                newPost.Content = activity.Text;
                newPost.DateTime = DateTime.Now;
                newPost.UserId = currentUser.Id;
                newPost.CircleId = "gym";
                newPost.Image = GeneralHelpers.UploadFile(FileUpload1);
                PostDAO.AddPost(newPost);

                rptUserPosts.DataSource = PostDAO.GetPostsByCircle("gym");
                rptUserPosts.DataBind();

            }
            catch (DbEntityValidationException ex)
            {
                var err = ex.EntityValidationErrors.FirstOrDefault().ValidationErrors.FirstOrDefault().ErrorMessage;
            }
        }
        protected void Comment_Click(object sender, EventArgs e)
        {
            try
            {
                foreach (RepeaterItem item in rptUserPosts.Items)
                {
                    TextBox comment = (TextBox)item.FindControl("hello");
                    var newPost = new BLL.Post();
                    newPost.Comment = comment.Text;
                    newPost.UserId = currentUser.Id;
                    newPost.CircleId = "gym";
                    PostDAO.AddPost(newPost);

                    rptUserPosts.DataSource = PostDAO.GetPostsByCircle("gym");
                    rptUserPosts.DataBind();

                }
            }
            catch (DbEntityValidationException ex)
            {
                var err = ex.EntityValidationErrors.FirstOrDefault().ValidationErrors.FirstOrDefault().ErrorMessage;
            }

        }


        protected string UploadThisFile(FileUpload upload)
        {
            if (upload.HasFile)
            {
                string filename = currentUser.Id + '-' + DateTime.Now.ToString("yyyyMMdd_hhmmss") + '-' + upload.FileName;
                string filepath = Server.MapPath(Path.Combine("/Content/images/shared/" + filename));
                upload.SaveAs(filepath);

                return "/Content/images/shared/" + filename;
            }

            return null;
        }


        protected void Btncircle_Click(object sender, EventArgs e)
        {


        }

        protected void rptUserPosts_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //Label tempLabel = (Label)e.Item.FindControl("lab_PostId");
            //string thepostid = tempLabel.Text;
            //GridView tempgv = (GridView)e.Item.FindControl("GridView1");
            //tempgv.DataSource = "";
            //tempgv.DataBind();
        }
    }
}
