﻿<%@ Page MasterPageFile="Header.master" AutoEventWireup="true" CodeBehind="Timeline.aspx.cs" Inherits="MyCircles.ItineraryPlanner.Timeline" Title="Timeline" %>

<asp:Content ContentPlaceHolderId="BodyContentPlaceHolder" runat="server">
    <link href="http://maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
    <form id="form1" runat="server">
        <div class="row d-flex justify-content-center mt-5">
            <h2><asp:Label ID="lbPlannerName" runat="server" Text="January Outing"></asp:Label></h2>
        </div>
        <div class="row mt-3">
            <div class="col-md-1"></div>
            <div class="col-md-1">
                <h2><asp:Label ID="lbMonth" runat="server" Text="Label"></asp:Label></h2> 
                <%--<input id="noOfDate" runat="server" ClientIdMode="Static"/>--%>
                <ul class="nav flex-column" >
                    <li class="nav-item">
                        <a id="aStartDate" class="nav-link active" href="#" runat="server"></a>
                    </li>
                   
                    <li class="nav-item">
                        <a id="aEndDate" class="nav-link" href="#" runat="server"></a>
                    </li>
                </ul>
              <%--  <asp:Repeater ID="rpDates" runat="server" ItemType="MyCircles.BLL.Itinerary">
                    <ItemTemplate>
                        <ul class="nav flex-column" >
                            <li class="nav-item">
                                <a id="aDate" class="nav-link active" href="#" runat="server"><%#DataBinder.Eval(Container.DataItem, "groupSize") %></a>
                            </li>
                        </ul>
                    </ItemTemplate>
                </asp:Repeater>--%>
            </div>
            <div class="col-md-8 border border-primary">
                <div class="row pt-3">
                    <div class="col-md-2 mr-1">
                        <h4>10.00am</h4> <br />
                        <h4>12.00pm</h4>
                    </div>
                    <div class="col-md-3 mr-1">
                        image
                    </div>
                    <div class="col-md-5">
                        Appreciate the majesty of exotic and endangered animals at Singapore Zoo, home to the world's largest collection of orangutans housed
                    </div>
                </div>
            </div>
            <div class="col-md-1">
                <a href="RequestFund.aspx" class="text-decoration-none">Request Fund<i class="fas fa-headset"></i></a>
            </div>
            <div class="col-md-1"></div>
        </div>
    </form>
    <script>
        var dayStr1 = '<%= dayStr1 %>';
        var singleDate = dayStr1.split(",");
        singleDate.reverse();
        console.log(dayStr1);
        console.log(singleDate);

          for (var i = 0; i < singleDate.length; i++) {
              var d1 = document.getElementById("BaseContentPlaceholder_SignedInContentPlaceholder_BodyContentPlaceHolder_aStartDate");
              d1.insertAdjacentHTML('afterend', '<a id="amDate" class="nav-link" href="#" runat="server">' + singleDate[i] + '</a>');
          }
        
    </script>
</asp:Content>