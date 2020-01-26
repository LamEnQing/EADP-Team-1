﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using Reimers.Google.Map;
using MyCircles.BLL;
using static MyCircles.DAL.UserDAO;
using MyCircles.DAL;
using System.Configuration;

namespace MyCircles.Profile
{
    //TODO: Edit profile with messages if mutuals/don't show location on map
    //TODO: Show whether or not user is online

    public partial class User : System.Web.UI.Page
    {
        public BLL.User currentUser, requestedUser;

        protected void Page_Load(object sender, EventArgs e)
        {
            RedirectValidator.isUser();
            currentUser = (BLL.User)Session["currentUser"];

            string requestedUsername = Request.QueryString["username"];
            requestedUser = GetUserByIdentifier(requestedUsername);

            if (requestedUser == null) requestedUser = currentUser;

            Title = requestedUser.Username + " - MyCircles";            
            ProfilePicImage.ImageUrl = requestedUser.ProfileImage;
            lbName.Text = requestedUser.Name;
            lbUsername.Text = "@" + requestedUser.Username;
            lbBio.InnerText = requestedUser.Bio;
            lbCity.InnerText = requestedUser.City;
            rptUserFollowing.DataSource = FollowDAO.GetAllFollowingUsers(requestedUser.Id);
            rptUserFollowing.DataBind();

            if (String.IsNullOrEmpty(requestedUser.Bio)) lbBio.Visible = false;
            if (rptUserFollowing.Items.Count > 0) followWarning.Visible = false;

            if (requestedUser.Id == currentUser.Id)
            {
                btFollow.Visible = false;
            }
            else
            {
                if (BLL.Admin.RetrieveAdmin(currentUser) != null)
                {
                    System.Diagnostics.Debug.WriteLine("Checking if admin");
                    cbMakeEventHost.Visible = true;
                    if (!Page.IsPostBack) cbMakeEventHost.Checked = requestedUser.IsEventHolder;
                }
                btEditProfile.Visible = false;
                followWarning.InnerText = requestedUser.Name + " has not followed anyone yet";
                postWarning.InnerText = requestedUser.Name + " has not created any posts yet";
                circleWarning.InnerText = requestedUser.Name + " has not followed any circles yet";
                
                updateFollowButton();

                if (FollowDAO.SearchFollow(requestedUser.Id, currentUser.Id) != null) followBadge.Visible = true;
            }

            GMap.ApiKey = ConfigurationManager.AppSettings["MapKey"];

            if (currentUser.Latitude != null || currentUser.Longitude != null)
            {
                LatLng currentPos = new LatLng();
                double currentLat = (this.currentUser.Latitude.HasValue) ? this.currentUser.Latitude.Value : 0;
                double currentLng = (this.currentUser.Longitude.HasValue) ? this.currentUser.Longitude.Value : 0;

                currentPos.Latitude = currentLat;
                currentPos.Longitude = currentLng;
                GMap.Center = currentPos;
                var marker = new Marker(currentPos);

                GMap.Overlays.Add(marker);
            }
        }

        protected void btFollow_Click(object sender, EventArgs e)
        {
            int requestedUserId = requestedUser.Id;
            Button button = (Button)sender;

            if (button.Attributes["UserId"] != null) requestedUserId = int.Parse(button.Attributes["UserId"]);

            FollowDAO.ToggleFollow(currentUser.Id, requestedUserId);
            updateFollowButton();
        }

        protected void btMessage_Click(object sender, EventArgs e)
        {
            Response.Redirect("User.aspx?username=" + currentUser.Username);
        }

        protected void cbMakeEventHost_CheckedChanged(object sender, EventArgs e)
        {
            if (sender is CheckBox)
            {
                CheckBox cbSender = (CheckBox) sender;
                System.Diagnostics.Debug.WriteLine("Updating user's event host: " + cbSender.Checked);
                requestedUser.UpdateIsEventHost(cbSender.Checked);
            }
        }

        protected void updateFollowButton()
        {
            Follow existingFollow = FollowDAO.SearchFollow(currentUser.Id, requestedUser.Id);

            if (existingFollow == null)
            {
                btFollow.Text = "Follow";
                btFollow.CssClass = "btn btn-outline-primary float-right m-5 px-4";
            }
            else
            {
                btFollow.Text = "Following";
                btFollow.CssClass = "btn btn-primary float-right m-5 px-4";
            }
        }
    }
}