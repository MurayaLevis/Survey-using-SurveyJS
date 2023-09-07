<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="SurveyTrial.HomePage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Home Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Welcome to Our Website!</h1>
<%--            <asp:Button ID="btnTakeSurvey" runat="server" Text="Take Survey" OnClick="btnTakeSurvey_Click" />
            <asp:Button ID="btnViewSurveys" runat="server" Text="View Surveys" OnClick="btnViewSurveys_Click" />--%>
            <asp:Button ID="btnFetchSurveys" runat="server" Text="Fetch Surveys" OnClick="btnFetchSurveys_Click" />
            <asp:Button ID="btnResponses" runat="server" Text="View Responses" OnClick="btnResponses_Click" />
            <%--<asp:Button ID="btnEdit" runat="server" Text="Edit Responses" OnClick="btnEditResponses_Click" />--%>
        </div>
    </form>
</body>
</html>
