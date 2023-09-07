<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateSurvey.aspx.cs" Inherits="SurveyTrial.CreateSurvey" %>

<!DOCTYPE html>

<!DOCTYPE html>
<html>
<head>
    <title>Create Survey</title>
</head>
<body>
    <h2>Create a New Survey</h2>
    <form id="surveyForm">
        <label for="surveyTitle">Survey Title:</label>
        <input type="text" id="surveyTitle" required>

        <div id="surveyEditor"></div>

        <button type="button" onclick="saveSurvey()">Save Survey</button>
    </form>

    <script src="https://unpkg.com/survey-jquery"></script>
    <script>
        var surveyJSON = {
            pages: [
                {
                    name: "page1",
                    elements: [
                        {
                            type: "text",
                            name: "question1",
                            title: "Enter your question here:",
                            isRequired: true
                        }
                    ]
                }
            ]
        };

        var surveyEditor = new SurveyEditor.SurveyEditor("surveyEditor", {
            showJSONEditorTab: false
        });
        surveyEditor.text = JSON.stringify(surveyJSON);

        function saveSurvey() {
            var surveyTitle = document.getElementById("surveyTitle").value;
            var surveyJson = surveyEditor.text;

            var data = {
                SurveyTitle: surveyTitle,
                SurveyJson: surveyJson
            };

            $.ajax({
                type: "POST",
                url: "api/Survey/CreateSurvey",
                data: JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                success: function () {
                    alert("Survey created successfully!");
                },
                error: function () {
                    alert("Error creating survey!");
                }
            });
        }
    </script>
</body>
</html>

