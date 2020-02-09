﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MyCircles.BLL;
namespace MyCircles.Events
{
    public partial class ViewEventDetails : System.Web.UI.Page
    {
        public Event singleEventDetails;
        public List<EventSchedule> eventSchedule;
        public int totalAvaliableSlots = 0;
        public string avaliableSlotsText = "";
        public int TotalBookedSlot = 0;
        // public BLL.Event event1 = 
        // List<String> means the list inside must be string ,List<EventSchedule> means the list must be include EventSchedule fields in table 
        // List<String> scheduleList = new List<String>();
        protected void Page_Load(object sender, EventArgs e)
        {
            int requestedEventId = int.Parse(Request.QueryString["eventID"]);
            // Get single Event Details from the db 
            singleEventDetails = BLL.Event.GetEvent(requestedEventId);

            // Get all event schedule data base on id
            getEventScheduleData(requestedEventId);
            getAllSignUpDetails(requestedEventId);
        }

        // get all the event scheduleData function
        private void getEventScheduleData(int eventId)
        {
            EventSchedule retrieveEventSchedule = new EventSchedule();
            List<EventSchedule> scheduleList = new List<EventSchedule>();
            
            scheduleList = retrieveEventSchedule.getAllEventActivity(eventId);

            //System.Diagnostics.Debug.WriteLine("gh say: " + scheduleList);
            rpEventSchedule.DataSource = scheduleList;
            rpEventSchedule.DataBind();
        }

        private void getAllSignUpDetails(int eventId)
        {
            SignUpEventDetail retrieveSignUpDetail = new SignUpEventDetail();
            List<SignUpEventDetail> signUpEventDetailsList = new List<SignUpEventDetail>();

            signUpEventDetailsList = retrieveSignUpDetail.GetSignUpEventDetails(eventId);
            // signUpEventDetailList have no data
            System.Diagnostics.Debug.WriteLine("gh say: " + signUpEventDetailsList.Count());
            
            foreach (SignUpEventDetail signUpEventDetailsListBB in signUpEventDetailsList)
            {
                var numberOfBookingSlot = signUpEventDetailsListBB.numberOfBookingSlot.ToString();
              
                TotalBookedSlot += Int32.Parse(numberOfBookingSlot);
                System.Diagnostics.Debug.WriteLine("dinesh say: " + TotalBookedSlot);
            }
            if (singleEventDetails.eventMaxSlot == "No Limit")
            {
                avaliableSlotsText = "No Limit";
            }
            else
            {
                totalAvaliableSlots = Int32.Parse(singleEventDetails.eventMaxSlot) - TotalBookedSlot;
            }

        }


    }
}