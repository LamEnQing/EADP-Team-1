﻿using MyCircles.BLL;
using MyCircles.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyCircles.Profile
{
    public partial class Chat : System.Web.UI.Page
    {
        public int chatRoomId;
        public BLL.User currentUser;
        public BLL.User recieverUser;

        //TODO: Do validation for the chatroom
        protected void Page_Load(object sender, EventArgs e)
        {
            RedirectValidator.isUser();

            try
            {
                chatRoomId = Convert.ToInt32(Request.QueryString["chatroom"]);
                currentUser = (BLL.User)Session["currentUser"];
                recieverUser = UserDAO.GetUserById(ChatRoomDAO.GetRecieverId(currentUser.Id, chatRoomId));
            }
            catch (Exception ex)
            {
                Response.Redirect("/Home/Post.aspx");
            }
        }

        [WebMethod]
        public static object GetAllMessages(int chatRoomId, int recieverId, int senderId)
        {
            var allMessages = MessageDAO.GetChatRoomMessages(chatRoomId);
            MessageDAO.SetMessageSeenStatus(chatRoomId, senderId);
            return new { result = allMessages };
        }

        [WebMethod]
        public static object GetNewMessages(int chatRoomId, int recieverId, int senderId)
        {
            var newMessages = MessageDAO.GetNewChatRoomMessages(chatRoomId, senderId);
            MessageDAO.SetMessageSeenStatus(chatRoomId, senderId);
            return new { result = newMessages };
        }

        [WebMethod]
        public static object AddNewMessage(int chatRoomId, int recieverId, int senderId, string messageContent, string latitude = null, string longitude = null)
        {
            Message newMessage = MessageDAO.AddMessage(chatRoomId, messageContent, recieverId, senderId, latitude, longitude);
            return new { result = newMessage };
        }
    }
}