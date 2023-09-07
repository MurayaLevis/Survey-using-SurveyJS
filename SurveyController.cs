
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Data.Entity;
using Newtonsoft.Json;

namespace SurveyTrial.Controllers
{
    public class SurveyData
    {
        public string satisfaction { get; set; }
        public string cleanliness { get; set; }
        public string staffFriendliness { get; set; }
        public string waitingTime { get; set; }
        public string overallExperience { get; set; }
        public string patientName { get; set; }
        public string PatientName { get; set; }
        public string SurveyTitle { get; set; }
        public string SurveyJSON { get; set; }
        public string title { get; set; }
        public string responses { get; set; }
        public string surveyTitle { get; set; }
        public string UserName { get; set; }
        public string updatedResponses { get; set; }
    }
    public class Responses
    {
        public string patientName { get; set; }
        public string title { get; set; }
        public string responses { get; set; }
    }
    public class Survey
    {
        public string SurveyTitle { get; set; }
        public string SurveyJSON { get; set; }
    }
    public class UpdatedResponseData
    {
        public string SurveyTitle { get; set; }
        public Dictionary<string, string> SurveyResponses { get; set; }
        public string PatientName { get; set; }
    }

    [EnableCors(origins: "*", headers: "*", methods: "*")]
    public class SurveyController : ApiController
    {
        [HttpPost]
        [Route("api/Survey/CreateSurvey")]
        public IHttpActionResult CreateSurvey([FromBody] SurveyData surveyData)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;"; 

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string insertQuery = "INSERT INTO Storedsurveys (SurveyTitle, SurveyJson) VALUES (@title, @json)";

                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@title", surveyData.SurveyTitle);
                        command.Parameters.AddWithValue("@json", surveyData.SurveyJSON);

                        command.ExecuteNonQuery();
                    }

                    connection.Close();
                }

                return Ok("Survey configuration saved successfully!");
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
        [HttpPost]
        [Route("api/Survey/SaveSurvey")]
        public IHttpActionResult SaveSurvey([FromBody] SurveyData surveyData)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string insertQuery = "INSERT INTO Survey (satisfaction, cleanliness, staff, time, experience, patientName) VALUES (@satisfaction, @cleanliness, @staffFriendliness, @waitingTime, @overallExperience, @patientName)";

                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@satisfaction", surveyData.satisfaction);
                        command.Parameters.AddWithValue("@cleanliness", surveyData.cleanliness);
                        command.Parameters.AddWithValue("@staffFriendliness", surveyData.staffFriendliness);
                        command.Parameters.AddWithValue("@waitingTime", surveyData.waitingTime);
                        command.Parameters.AddWithValue("@overallExperience", surveyData.overallExperience);
                        command.Parameters.AddWithValue("@patientName", surveyData.patientName);

                        command.ExecuteNonQuery();
                    }
                    connection.Close();
                }
                return Ok();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving survey data: " + ex.Message);
                return InternalServerError();
            }
        }
        [HttpGet]
        [Route("api/Survey/GetSurveyResponses/{PatientName}")]
        public IHttpActionResult GetSurveyResponses(string PatientName)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";
                List<Responses> savedResponses = new List<Responses>();

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string selectQuery = "SELECT title, responses, PatientName FROM SavedSurveys WHERE PatientName = @PatientName";

                    using (SqlCommand command = new SqlCommand(selectQuery, connection))
                    {
                        command.Parameters.AddWithValue("@PatientName", PatientName);
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Responses surveyData = new Responses
                                {
                                    title = reader["title"].ToString(),
                                    responses = reader["responses"].ToString(),
                                    patientName = reader["PatientName"].ToString()
                                };
                                savedResponses.Add(surveyData);
                            }
                        }
                    }

                    connection.Close();
                }
                string surveyResponsesJSON = Newtonsoft.Json.JsonConvert.SerializeObject(savedResponses);
                return Ok(surveyResponsesJSON);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error fetching saved responses: " + ex.Message);
                return InternalServerError();
            }
        }

        [HttpGet]
        [Route("api/Survey/GetSurveyByTitles/{title}")]
        public IHttpActionResult GetSurveyByTitle(string title)
        {
            try
            {
                 string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string selectQuery = "SELECT SurveyTitle, SurveyJson FROM Storedsurveys where SurveyTitle = @title ";

                    using (SqlCommand command = new SqlCommand(selectQuery, connection))
                    {
                        command.Parameters.AddWithValue("@title", title);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Survey surveyData = new Survey
                                {
                                    SurveyTitle = reader["SurveyTitle"].ToString(),
                                    SurveyJSON = reader["SurveyJson"].ToString()
                                };

                                return Ok(surveyData);
                            }
                            else
                            {
                                return NotFound();
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
        [HttpGet]
        [Route("api/Survey/GetSurveyTitles")]
        public IHttpActionResult GetSurveyTitles()
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";

                List<string> surveyTitles = new List<string>();

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string selectQuery = "SELECT SurveyTitle FROM Storedsurveys";

                    using (SqlCommand command = new SqlCommand(selectQuery, connection))
                    {
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string title = reader["SurveyTitle"].ToString();
                                surveyTitles.Add(title);
                            }
                        }
                    }
                }

                return Ok(surveyTitles);
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
        [HttpGet]
        [Route("api/Survey/GetSurveyResponsesByPatient/{patientName}")]
        public IHttpActionResult GetSurveyResponsesByPatient(string patientName)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";

                List<SurveyData> surveyResponses = new List<SurveyData>();

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string selectQuery = "SELECT satisfaction, cleanliness, staff, time, experience FROM Survey WHERE patientName = @PatientName";

                    using (SqlCommand command = new SqlCommand(selectQuery, connection))
                    {
                        command.Parameters.AddWithValue("@PatientName", patientName);

                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                SurveyData response = new SurveyData
                                {

                                    satisfaction = reader["satisfaction"].ToString(),
                                    cleanliness = reader["cleanliness"].ToString(),
                                    staffFriendliness = reader["staff"].ToString(),
                                    waitingTime = reader["time"].ToString(),
                                    overallExperience = reader["experience"].ToString()
                                };
                                surveyResponses.Add(response);
                            }
                        }
                    }
                    connection.Close();
                }
                string surveyResponsesJSON = Newtonsoft.Json.JsonConvert.SerializeObject(surveyResponses);
                return Ok(surveyResponsesJSON);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error fetching survey responses: " + ex.Message);
                return InternalServerError();
            }
        }

        [HttpPost]
        [Route("api/Survey/SaveSurveyResponses")]
        public IHttpActionResult SaveSurveyResponses([FromBody] SurveyData surveyData)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string insertQuery = "INSERT INTO SavedSurveys (title, PatientName, responses) VALUES (@title, @PatientName, @responses)";

                    using (SqlCommand command = new SqlCommand(insertQuery, connection))
                    {
                        command.Parameters.AddWithValue("@title", surveyData.title);
                        command.Parameters.AddWithValue("@PatientName", surveyData.UserName);
                        command.Parameters.AddWithValue("@responses", surveyData.responses);
                        command.ExecuteNonQuery();
                    }

                    connection.Close();
                }

                return Ok();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving survey data: " + ex.Message);
                return InternalServerError();
            }
        }

        [HttpPost]
        [Route("api/Survey/UpdateSavedResponses/{patientName}")]
        public IHttpActionResult UpdateSavedResponses(string patientName, [FromBody] UpdatedResponseData updatedData)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string deleteQuery = "DELETE FROM SavedSurveys WHERE PatientName = @PatientName";

                    using (SqlCommand deleteCommand = new SqlCommand(deleteQuery, connection))
                    {
                        deleteCommand.Parameters.AddWithValue("@PatientName", patientName);
                        deleteCommand.ExecuteNonQuery();
                    }

                    string insertQuery = "INSERT INTO SavedSurveys (title, responses, PatientName) VALUES (@SurveyTitle, @SurveyResponses, @PatientName)";

                    using (SqlCommand insertCommand = new SqlCommand(insertQuery, connection))
                    {
                        insertCommand.Parameters.AddWithValue("@SurveyTitle", updatedData.SurveyTitle);
                        insertCommand.Parameters.AddWithValue("@SurveyResponses", Newtonsoft.Json.JsonConvert.SerializeObject(updatedData.SurveyResponses));
                        insertCommand.Parameters.AddWithValue("@PatientName", patientName);
                        insertCommand.ExecuteNonQuery();
                    }

                    connection.Close();
                }

                return Ok();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating saved responses: " + ex.Message);
                return InternalServerError();
            }
        }

        [HttpGet]
        [Route("api/Survey/GetSavedResponses/{patientName}")]
        public IHttpActionResult GetSavedResponses(string patientName)
        {
            try
            {
                string connectionString = "Data Source=LEVISPC;Initial Catalog=Test;User ID=smartenduser;Password=l0l0t1ng@2209;";
                List<Responses> savedResponses = new List<Responses>();

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();

                    string selectQuery = "SELECT title, responses, PatientName FROM SavedSurveys WHERE PatientName = @PatientName";

                    using (SqlCommand command = new SqlCommand(selectQuery, connection))
                    {
                        command.Parameters.AddWithValue("@PatientName", patientName);
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                Responses surveyData = new Responses
                                {
                                    title = reader["title"].ToString(),
                                    responses = reader["responses"].ToString(),
                                    patientName = reader["PatientName"].ToString()
                                };
                                savedResponses.Add(surveyData);
                            }
                        }
                    }

                    connection.Close();
                }

                return Ok(savedResponses);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error fetching saved responses: " + ex.Message);
                return InternalServerError();
            }
        }


    }
}