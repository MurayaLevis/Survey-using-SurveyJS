using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SurveyTrial
{
    public partial class SaveSurvey : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                string question1Value = Request.Form["question1"];
                string question2Value = Request.Form["question2"];

                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string insertQuery = "INSERT INTO Survey (Quiz1, Quiz2) VALUES (@Question1, @Question2)";

                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@Question1", question1Value);
                        command.Parameters.AddWithValue("@Question2", question2Value);

                        command.ExecuteNonQuery();
                    }
                    connection.Close();
                }
                Response.Redirect("Survey.aspx");
            }
        }
    }
}