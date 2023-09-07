<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Survey.aspx.cs" Inherits="SurveyTrial.Survey" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Survey Page</title>
    
    <link href="Styles/survey.css" type="text/css" rel="stylesheet" />
</head>
<body>
    
        <div id="surveyElement"></div>
        <button type="button" onclick="submitSurvey()">Submit Survey</button>
       <%-- <button type="button" onclick="viewSurveyResponses()">View Survey Responses</button>--%>

        <button type="button" onclick="viewSurveyResponses()">View Survey Responses</button>
        <button type="button" onclick="FetchSurvey()">Fetch Surveys</button>
        <button onclick="Home()">Home</button>
   
        <!--<form id="surveyForm" action="SaveSurvey.aspx" method="post"> 
        <div id="surveyElement"></div>
        <button type="submit">Submit Survey</button>
    </form>-->
    <!--<form id="surveyForm" action="api/Survey/SaveSurvey" method="post">
            <div id="surveyElement"></div>
        <button type="submit">Submit Survey</button>
    </form>-->
  
    <script src="Scripts/survey.angular.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        function Home() {
            window.location.href = "HomePage.aspx";
        }

        var surveyResponses = {
            patientName:"",
            satisfaction: "",
            cleanliness: "",
            staffFriendliness: "",
            waitingTime: "",
            overallExperience: ""
        };

        var surveyJSON = {
            title: "Hospital Experience Survey",
            pages: [
                {
                    name: "page1",
                    elements: [
                        {
                            type: "text",
                            name: "patientName",
                            title: "Please enter your name:",
                            isRequired: true
                        },
                        {
                            type: "radiogroup",
                            name: "satisfaction",
                            title: "How satisfied are you with the quality of medical care received?",
                            choices: ["Very Satisfied", "Satisfied", "Neutral", "Dissatisfied", "Very Dissatisfied"],
                        
                        },
                        {
                            type: "radiogroup",
                            name: "cleanliness",
                            title: "How would you rate the cleanliness and hygiene of the hospital?",
                            choices: ["Excellent", "Good", "Average", "Poor", "Very Poor"],
                        },
                        {
                            type: "radiogroup",
                            name: "staffFriendliness",
                            title: "How friendly and helpful were the hospital staff during your visit?",
                            choices: ["Extremely Friendly", "Friendly", "Neutral", "Unfriendly", "Very Unfriendly"],
                        },
                        {
                            type: "radiogroup",
                            name: "waitingTime",
                            title: "How would you rate the waiting time for appointments and services?",
                            choices: ["Short", "Reasonable", "Average", "Long", "Very Long"],
                        },
                        {
                            type: "radiogroup",
                            name: "overallExperience",
                            title: "Overall, how would you rate your experience at the hospital?",
                            choices: ["Excellent", "Good", "Average", "Poor", "Very Poor"],
                        }
                    ]
                }
            ]
        };
        var survey = new Survey.Model(surveyJSON);

        survey.render("surveyElement");

        survey.onComplete.add(submitSurvey);

        function viewSurveyResponses() {
            window.location.href = "Response.aspx";
        }
        function FetchSurvey() {
            window.location.href = "FetchSurvey.aspx";
        }


        function submitSurvey(sender) {
            surveyResponses.patientName = survey.data.patientName;
            var resultAsJSON = JSON.stringify(sender.data);
            $.ajax({
                type: "POST",
                url: "api/Survey/SaveSurvey",
                data: resultAsJSON,
                contentType: "application/json; charset=utf-8",
                success: function () {
                    alert("Survey submitted successfully!");
                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                    alert("Error submitting survey: " + error);
                }
            });
        }
    </script>
</body>
</html>

