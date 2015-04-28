﻿<%@ Page Language="C#" MasterPageFile="~/app/AppMasterPage.master" AutoEventWireup="true" CodeFile="search.aspx.cs" Inherits="app_search" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <div style="background-color: #394165;border-color: #343a5c;height: 50px;margin-bottom: 10px;color: #fff;">
           <div class="Width960"><h1>Search for Journalists</h1></div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder3" Runat="Server">
    <div class="SearchItemsContainer">
        <table>
            <tr>
                <td colspan="6">Search for any keyword, company, topic, phrase and more within journalists' tweets, linked stories, published articles and social media profiles.</td>
            </tr>
            <tr>
                <td style="width:100px">Keyword</td>
                <td><asp:TextBox runat="server" ID="txtkeyword" CssClass="SearchTextBoxes" Text="e.g. Editor" onfocus='if (this.value == "e.g. Editor"){this.value = "";}' onblur='if (this.value == ""){this.value = "e.g. Editor"}' /></td>
                <td style="width:100px"></td>
                <td style="width:100px">Journalist</td>
                <td style="text-align:right"><asp:TextBox runat="server" ID="txtJournoName" CssClass="SearchTextBoxes" Text="e.g. Karima Brown" onfocus='if (this.value == "e.g. Karima Brown"){this.value = "";}' onblur='if (this.value == ""){this.value = "e.g. Karima Brown"}'  /></td>
            </tr>
            <tr>
            </tr>
            <tr>
                <td>Location</td>
                <td><asp:TextBox runat="server" ID="txtLocation" CssClass="SearchTextBoxes" Text="e.g. Johannesburg" onfocus='if (this.value == "e.g. Johannesburg"){this.value = "";}' onblur='if (this.value == ""){this.value = "e.g. Johannesburg"}' /></td>
                <td style="width:100px"></td>
                <td >Media Outlet</td>
                <td style="text-align:right"><asp:DropDownList runat="server" ID="ddPublication" DataSourceID="dsPublications" DataTextField="Publication" DataValueField="PublicationID" CssClass="SearchDropDowns"/></td>
            </tr>
            <tr>
            </tr>
            <tr runat="server" visible="false">
                <td>Beat</td>
                <td><asp:DropDownList runat="server" ID="ddBeatID" DataSourceID="dsBeats" DataTextField="BeatName" DataValueField="BeatID" CssClass="SearchDropDowns"/></td>
                <td style="width:100px"></td>
                <td>Topic</td>
                <td style="text-align:right"><asp:TextBox runat="server" ID="txtTopic" CssClass="SearchTextBoxes" Text="e.g. Fifa World Cup" onfocus='if (this.value == "e.g. Fifa World Cup"){this.value = "";}' onblur='if (this.value == ""){this.value = "e.g. Fifa World Cup"}' /></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td style="width:100px"></td>
                <td></td>
                <td><asp:Button runat="server" ID="btnSearch" Text="Search" OnClick="btnSearch_Click" CssClass="SearchButton" /></td>
            </tr>
        </table>
    </div>
    <div class="RightContainer">
        <div>
            <h3>Last 5 Searches</h3>
            <asp:Literal runat="server" ID="litUserJournalistSearchesResult" Text="You do not have any saved searches." Visible="false"></asp:Literal>
            <asp:Repeater runat="server" ID="rptUserJournalistSearches" DataSourceID="dsUserJournalistSearch">          
                <ItemTemplate>
                    <a href='<%# "/app/journalists/search.aspx?sci=" + Eval("UserJournalistSearchID") %>'>
                        <div class="JournalistSearches">
                            <div class="PublicationName"> <%# Convert.ToDateTime(Eval("DateTimeStamp")).ToString("dd MMM yyyy") %> </div>
                            <div class="PublicationName"> <%# Eval("SearchCriteria") %> </div>
                        </div>
                     </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>                                                         
    <div class="ResultsContainer">
        <h3><asp:Literal runat="server" ID="litSearchHeading" Text="Recently Added Jounalists" /></h3>
        <asp:Literal runat="server" ID="litSearchResult" Text="No journalists found. Please refine your search criteria." Visible="false" />
        <asp:repeater runat="server" id="rptJournalists" DataSourceID="dsJournalists">
            <itemtemplate>
                <div class="JobHistoryContainer">
                    <div class="PublicationImage" style='<%# "background-image:url(" + Eval("ProfileImage") + ")" %>'></div>
                    <div class="CommunicatorName"> <%# Eval ("FirstName") + " " + Eval("LastName") %> </div>
                    <div class="PublicationName"> <%# Eval ("CurrentJobTitle") %> </div>
                    <div class="PublicationName"> <%# Eval ("CurrentJobPublication")  %> </div>
                    <a class="ViewProfile" href='<%# "profile.aspx?uid=" + Eval("UserID") %>'>view profile</a>
                </div>
            </itemtemplate>
        </asp:repeater>
    </div>
    <asp:SqlDataSource ID="dsBeats" runat="server" ConnectionString="<%$ ConnectionStrings:CS %>"
        SelectCommand="SELECT BeatID, ISNULL(BeatName,'') AS BeatName FROM Beats UNION SELECT 0,'----------'">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsPublications" runat="server" ConnectionString="<%$ ConnectionStrings:CS %>"
        SelectCommand="SELECT PublicationID, ISNULL(Publication,'') AS Publication, ISNULL(Website,'') AS Website FROM Publications UNION SELECT 0,'----------','----------'">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsJournalists" runat="server" ConnectionString="<%$ ConnectionStrings:CS %>" SelectCommand="
        SELECT TOP 15 U.UserID, ISNULL(U.FirstName,'') AS FirstName,ISNULL(U.LastName,'') AS LastName, ISNULL(U.CurrentJobTitle,'') AS CurrentJobTitle, 
        ISNULL(U.CurrentJobPublication,'') AS CurrentJobPublication, (CASE WHEN ISNULL(U.TwitterProfileImageURL,'') = '' AND ISNULL(U.ImageFormat,'') = '' THEN 'http://test.idecode.co.za/app/images/profileimages/0.png' ELSE U.TwitterProfileImageURL END) AS ProfileImage , 
        ISNULL(U.BeatID,0) AS BeatID, ISNULL(U.CurrentCity,'') AS CurrentCity, ISNULL(U.ContactMobile,'') AS ContactMobile, ISNULL(U.ContactOffice,'') AS ContactOffice, ISNULL(U.FaxNumber,'') AS FaxNumber, ISNULL(U.EmailAddress,'') AS EmailAddress FROM Users U 
        INNER JOIN Publications P ON LOWER(P.Publication) = LOWER(U.CurrentJobPublication)
        LEFT OUTER JOIN UserArticles UA ON UA.UserID = U.UserID WHERE 
		U.UserTypeID = 2 AND U.Active = 1 AND ISNULL(U.FirstName,'') <> '' AND ISNULL(U.LastName,'') <> '' AND ISNULL(TwitterUsername,'') <> '' 
		ORDER BY LastUpdatedDate DESC">
        <SelectParameters>
            <asp:SessionParameter SessionField="kqy" Name="Keyword" DefaultValue="aabbcc" />
            <asp:SessionParameter SessionField="jn" Name="JounalistName" DefaultValue="aabbcc" />
            <asp:SessionParameter SessionField="bid" Name="BeatID" DefaultValue="0" />
            <asp:SessionParameter SessionField="mid" Name="MediaOutletID" DefaultValue="0" />
            <asp:SessionParameter SessionField="l" Name="Location" DefaultValue="aabbcc" />
            <asp:SessionParameter SessionField="t" Name="Topic" DefaultValue="aabbcc" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="dsUserJournalistSearch" runat="server" ConnectionString="<%$ ConnectionStrings:CS %>" SelectCommand="
            SELECT TOP 5 UserJournalistSearchID, ISNULL(UserID,0) AS UserID, 
                ISNULL(Keywords,'') AS Keywords, ISNULL(Journalist,'') AS Journalist,
                ISNULL(Location,'') AS Location, ISNULL(MediaOutletID,0) AS MediaOutletID,
                ISNULL(DateTimeStamp,GETDATE()) AS DateTimeStamp, 
                (ISNULL(Keywords,'') + ' ' + ISNULL(Journalist,'') + ' ' + ISNULL(Location,'')) AS SearchCriteria 
                FROM UserJournalistSearches
                WHERE UserID = @UserID ORDER BY UserJournalistSearchID DESC" >
        <SelectParameters>
            <asp:SessionParameter SessionField="iUserID" Name="UserID" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPlaceHolder4" Runat="Server">
</asp:Content>
