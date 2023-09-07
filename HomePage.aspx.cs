using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SurveyTrial
{
    public partial class HomePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnTakeSurvey_Click(object sender, EventArgs e)
        {
            Response.Redirect("Survey.aspx");
        }

        protected void btnViewSurveys_Click(object sender, EventArgs e)
        {
            Response.Redirect("Response.aspx");
        }
        protected void btnFetchSurveys_Click(object sender, EventArgs e)
        {
            Response.Redirect("FetchSurvey.aspx");
        }
        protected void btnResponses_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewResponses.aspx");
        }
        protected void btnEditResponses_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditResponses.aspx");
        }
    }
}