﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyCircles.Admin
{
    public partial class ViewReportedPosts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            gvReportedPosts.DataSource = BLL.ReportedPost.GetAllUserReportedPosts();
            gvReportedPosts.DataBind();
        }
    }
}