 <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FetchSurvey.aspx.cs" Inherits="SurveyTrial.FetchSurvey" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html>
<head>
    <title>Survey List</title>
     <link href="https://unpkg.com/survey-jquery/defaultV2.min.css" type="text/css" rel="stylesheet">

</head>
<body>
        <div>
        <label for="userName">Your Name:</label>
        <input type="text" id="UserName" />
    </div>
    <div id="surveyContainer"></div>
    <h2>Available Surveys</h2>
    <select id="surveyDropdown"></select>
    <button type="button" onclick="loadSurvey()">Load Survey</button>
    <button type="button" onclick="Responses()">View Responses</button>
    <button onclick="Home()">Home</button>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script type="text/javascript" src="Scripts/survey.jquery.min.js"></script>
    <script>
        function Home() {
            window.location.href = "HomePage.aspx";
        }


        $.ajax({
            type: "GET",
            url: "api/Survey/GetSurveyTitles",
            success: function (data) {
                var surveyDropdown = $("#surveyDropdown");
                data.forEach(function (title) {
                    surveyDropdown.append("<option value='" + title + "'>" + title + "</option>");
                });
            },
            error: function () {
                alert("Error fetching survey titles!");
            }
        });
        function Responses() {
            window.location.href = "ViewResponses.aspx";
        }

        function loadSurvey() {
            var selectedSurveyTitle = $("#surveyDropdown").val();
            console.log(selectedSurveyTitle);
            $.ajax({
                type: "GET",
                url: "api/Survey/GetSurveyByTitles/" + selectedSurveyTitle,
                success: function (data) {
                    var surveyJson = JSON.parse(data.SurveyJSON);
                    console.log(surveyJson)
                    var survey = new Survey.Model(surveyJson);
                    survey.onComplete.add(function (sender, options) {
                        console.log("Survey completed. Responses:", sender.data);
                        saveSurveyResponses(sender);
                    });
                    $(function () {
                        $("#surveyContainer").Survey({ model: survey });
                    });

                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                    alert("Error fetching survey: " + error);
                }
            });
        }

        function saveSurveyResponses(sender) {
            var selectedSurveyTitle = $("#surveyDropdown").val();
            var UserName = $("#UserName").val();
            var surveyData = {
                title: selectedSurveyTitle,
                UserName: UserName,
                responses: JSON.stringify(sender.data) 
            };

            $.ajax({
                type: "POST",
                url: "api/Survey/SaveSurveyResponses",
                contentType: "application/json", 
                data: JSON.stringify(surveyData), 
                success: function (data) {
                    alert("Survey responses saved successfully!");
                    window.close();
                    window.location.href = "HomePage.aspx";
                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                    alert("Error saving survey responses: " + error);
                }
            });
        }

    </script>
</body>
</html>

