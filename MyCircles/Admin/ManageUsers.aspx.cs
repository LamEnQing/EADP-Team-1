﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MyCircles.BLL;

namespace MyCircles.Admin
{
    public partial class ManageUsers : System.Web.UI.Page
    {
        private List<User> userList;

        protected void Page_Load(object sender, EventArgs e)
        {
            List<User> users = BLL.User.GetAllUsers();

            this.userList = users;
            gvUsers.DataSource = users;
            gvUsers.DataBind();
        }

        protected void btnSearchSubmit_Click(object sender, EventArgs e)
        {
            string inputStr = tbSearchInput.Text;
            List<User> users = BLL.User.GetAllUsers();

            System.Diagnostics.Debug.WriteLine("search submit with:" + inputStr);

            if (!inputStr.Equals("")) // Search is not empty
            {
                tbSearchInput.BorderColor = System.Drawing.Color.Empty;
                List<User> resultUserList = new List<User>();
                foreach (User user in users)
                {
                    if (user.Username.Contains(inputStr))
                    {
                        resultUserList.Add(user);
                    }
                    else if (user.Name.Contains(inputStr))
                    {
                        resultUserList.Add(user);
                    }
                    else if (user.EmailAddress.Contains(inputStr))
                    {
                        resultUserList.Add(user);
                    }
                }

                this.userList = resultUserList;
                gvUsers.DataSource = resultUserList;
                gvUsers.DataBind();
            }
            else
            {
                tbSearchInput.BorderColor = System.Drawing.Color.Red;
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idx = int.Parse(e.CommandArgument.ToString());
            User user = userList[idx];
            switch (e.CommandName)
            {
                case "ChgUserStatus":
                    user.UpdateIsDisabled(!user.IsDeleted);
                    this.userList = BLL.User.GetAllUsers();
                    gvUsers.DataSource = userList;
                    gvUsers.DataBind();
                    break;
                case "UserProfile":
                    string profileLink = "/Profile/User.aspx?username=" + userList[idx].Username;
                    Response.Redirect(profileLink);
                    break;
            }
        }

        protected void gvUsers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                System.Diagnostics.Debug.WriteLine("gvUsers_RowDataBound:" + e.Row.Cells[0].Text);
                System.Diagnostics.Debug.WriteLine("gvUsers_RowDataBound:" + e.Row.RowIndex);
                User user = this.userList[e.Row.RowIndex];

                string displayChgUserStatus = "User";
                if (user.IsDeleted) // if disabled
                    displayChgUserStatus = "Re-enable " + displayChgUserStatus;
                else // if enabled
                    displayChgUserStatus = "Disable " + displayChgUserStatus;
                System.Diagnostics.Debug.WriteLine("gvUsers_RowDataBound:" + user.IsDeleted);

                //Control 
                //(e.Row.Cells[3].Controls[0] as Button).Text = displayChgUserStatus;
            }
        }
    }
}