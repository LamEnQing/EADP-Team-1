﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MyCircles.DAL.Joint_Models;
using MyCircles.BLL;

namespace MyCircles.Admin
{
    public partial class ViewReportedPosts : System.Web.UI.Page
    {
        private string keySessionRowIdx = "ViewReportedPostsRowIdx";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session[keySessionRowIdx] = -1;
            }

            refreshGridView();
        }

        protected void ModalDeleteBtn_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Debug.WriteLine("ModalDeleteBtn_Click," + Session[keySessionRowIdx]);
            int selectedRowIdx = (int) Session[keySessionRowIdx];
            if (selectedRowIdx > -1)
            {
                deleteOp(selectedRowIdx);
                System.Diagnostics.Debug.WriteLine("Delete Btn click!");
                
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "closeViewPostModal();", true);
        }

        protected void gvReportedPosts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idx = int.Parse(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "ViewPost":
                    System.Diagnostics.Debug.WriteLine("gvReportedPosts_RowCommand, ViewPost:" + e.CommandArgument);
                    UserReportedPost userReportedPost = getDataList()[idx];
                    Post post = Post.GetPostById(userReportedPost.postId);
                    User postCreator = BLL.User.GetUserById(post.UserId);

                    System.Diagnostics.Debug.WriteLine("gv SelectedIndexChanged," + post.Id);
                    Session[keySessionRowIdx] = idx;

                    lblModalPostCreatorName.Text = postCreator.Username;

                    imgModalPost.ImageUrl = post.Image;
                    imgModalPost.Visible = post.Image != null;

                    lblModalContent.Text = post.Content;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openViewPostModal();", true);
                    break;
                case "DeletePost":
                    System.Diagnostics.Debug.WriteLine("gvReportedPosts_RowCommand, DeletePost:" + e.CommandArgument);
                    deleteOp(idx);
                    break;
            }
        }

        protected void gvReportedPosts_DataBound(object sender, EventArgs e)
        {
            int topRowIdx = -1;
            int currPostId = -1;
            int rowSpan = 0;

            for (int idx = 0; idx < getDataList().Count; idx++)
            {
                UserReportedPost report = getDataList()[idx];
                GridViewRow row = gvReportedPosts.Rows[idx];

                if (report.postId != currPostId) // new post for current report, not the same post as previous report
                {
                    // need to set row span when going to next post
                    if (currPostId > -1)
                    {
                        GridViewRow topRow = gvReportedPosts.Rows[topRowIdx];
                        topRow.Cells[3].RowSpan = rowSpan;
                        topRow.Cells[4].RowSpan = rowSpan;
                    }

                    rowSpan = 1; // resets row span to 1, because new row
                    topRowIdx = idx; // saves this top row
                    currPostId = report.postId;
                }
                else // current report's postId matches previous report's postId, so increase rowSpan
                {
                    row.Cells[3].Visible = false;
                    row.Cells[4].Visible = false;
                    rowSpan += 1;
                }

                if (idx == (getDataList().Count-1)) // when reaches the end of the row, we must assign the topRow thingy and stuffs
                {
                    GridViewRow topRow = gvReportedPosts.Rows[topRowIdx];
                    topRow.Cells[3].RowSpan = rowSpan;
                    topRow.Cells[4].RowSpan = rowSpan;
                }
            }

            //GridViewRow row = gvReportedPosts.Rows[0];
            //row.Cells[3].RowSpan = 2;
            //GridViewRow row1 = gvReportedPosts.Rows[1];
            //row1.Cells[3].Visible = false;
        }

        public void deleteOp(int index)
        {
            // TODO deleting from modal, index is out of range
            System.Diagnostics.Debug.WriteLine("deleteOp, index:" + index);
            UserReportedPost userReportedPost = getDataList()[index];
            Post post = Post.GetPostById(userReportedPost.postId);

            System.Diagnostics.Debug.WriteLine("deleteOp, postId:" + post.Id);

            // delete reportedpost data
            ReportedPost rp = ReportedPost.GetReportedPostById(userReportedPost.id);
            System.Diagnostics.Debug.WriteLine("deleteOp, reportedPost:" + rp.reason);
            ReportedPost.DeleteReportedPostByPostId(userReportedPost.postId);

            // delete post data
            Post.DeletePost(post.Id);

            // TODO - Investigate why cannot use remove, but removeRange can work for inside the DAO

            refreshGridView();
        }

        private void refreshGridView()
        {
            gvReportedPosts.DataSource = getDataList();
            gvReportedPosts.DataBind();
        }

        private List<UserReportedPost> getDataList()
        {
            return ReportedPost.GetAllUserReportedPostsSortByPostId();
        }
    }
}