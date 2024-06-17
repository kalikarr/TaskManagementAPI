<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="TaskManager.aspx.cs" Inherits="TaskManagementUI.Pages.TaskManager" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2>Task Manager</h2>
        <div class="form-row">
            <button id="addnewBtn" type="button" class="btn btn-primary ml-0 m-3" data-toggle="modal" data-target="#taskModal">Add Task</button>
            <button id="exportBtn" type="button" class="btn btn-success ml-0 m-3">Export to Excel</button>
            <button id="exportChartBtn"  type="button" class="btn btn-success ml-0 m-3" onclick="loadTaskChart()">View Chart</button>
        </div>

        <table class="table table-bordered table-striped ">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Task Name</th>
                    <th>Assigned To</th>
                    <th>Status</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="taskTableBody">
                <!-- Task rows will be dynamically added here -->
            </tbody>
        </table>
    </div>
    <div id="taskChart" style="width: 100%; height: 400px; margin-top: 20px; display: none;"></div>


    <div class="modal fade" id="taskModal" tabindex="-1" role="dialog" aria-labelledby="taskModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="taskModalLabel">Add/Edit Task</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="taskForm">
                        <input type="hidden" id="taskId" name="taskId">
                        <div class="form-group">
                            <label for="taskName">Task Name</label>
                            <input type="text" class="form-control" id="taskName" name="taskName" maxlength="100">
                            <div class="invalid-feedback">
                                Please enter a task name.
                       
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="taskDescription">Description</label>
                            <textarea class="form-control" id="taskDescription" name="taskDescription" maxlength="1000"></textarea>
                            <div class="invalid-feedback">
                                Please enter a task description.
                       
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="taskStatus">Task Status</label>
                            <select class="form-control" id="taskStatus" name="taskStatus">
                                <!-- Options will be dynamically populated -->
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="assignUser">Assign User</label>
                            <select class="form-control" id="assignUser" name="assignUser">
                                <!-- Options will be dynamically populated -->
                            </select>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="saveTaskButton">Save Task</button>
                </div>
            </div>
        </div>
    </div>
    <asp:PlaceHolder runat="server">
        <script>
            $(document).ready(function () {
              

                loadTasks(true);

                function loadTasks(reloadChart) {
                    let userId = $('#hdnUserId').val();
                    let token = $('#hdnToken').val();
                    $.ajax({
                        url: `https://localhost:44397/api/tasks/${userId}`,
                        type: 'GET',
                        headers: {
                            'Authorization': 'Bearer ' + token
                        },
                        success: function (tasks) {
                            var taskTableBody = $('#taskTableBody');
                            taskTableBody.empty();
                            tasks.forEach(task => {
                                var row = `<tr>
                                        <td>${task.TaskId}</td>
                                        <td>${task.TaskName}</td>
                                         <td>${task.AssignTo}</td>
                                         <td>${task.StatusName}</td>
                                        <td>${task.TaskDescription}</td>
                                        <td>
                                            <button class="btn btn-warning btn-sm"  type="button" onclick="editTask(${task.TaskId})">Edit</button>
                                            <button class="btn btn-danger btn-sm" type="button" onclick="deleteTask(${task.TaskId})">Delete</button>
                                        </td>
                                       </tr>`;
                                taskTableBody.append(row);
                            });
                            if (reloadChart) {
                                setTimeout(function () {
                                    loadTaskChart();
                                }, 3000);
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            showErrorMessage('Error fetching tasks, Please try again!');
                            console.error('Error fetching tasks:', textStatus, errorThrown);
                        }
                    });
                }
                
                $('#addnewBtn').click(function () {
                    $('#taskId').val('');
                    $('#taskName').val('');
                    $('#taskDescription').val('');
                    $('#taskName').removeClass('is-invalid');
                    $('#taskDescription').removeClass('is-invalid');
                    initDropdowns($('#hdnUserId').val(),1)
                });


                $('#saveTaskButton').click(function () {
                    if ($('#taskName').val().trim() === '') {
                        $('#taskName').addClass('is-invalid');
                        return;
                    }
                    else if ($('#taskDescription').val().trim() === '') {
                        $('#taskDescription').addClass('is-invalid');
                        return;
                    } else {
                        $('#taskName').removeClass('is-invalid');
                        $('#taskDescription').removeClass('is-invalid');
                    }
                    var task = {
                        TaskId: $('#taskId').val(),
                        TaskName: $('#taskName').val(),
                        TaskDescription: $('#taskDescription').val(),
                        UserId: $('#assignUser').val(),
                        StatusId: $('#taskStatus').val(),
                        CreatedById: $('#hdnUserId').val(),
                        LastUpdatedByUserId: $('#hdnUserId').val()
                    };

                    let method = task.TaskId ? 'PUT' : 'POST';
                    let endpoiint = task.TaskId ? 'updateTask' : 'createTask';
                    let token = $('#hdnToken').val();
                    $.ajax({
                        url: `https://localhost:44397/api/tasks/${endpoiint}`,
                        type: method,
                        headers: {
                            'Authorization': 'Bearer ' + token
                        },
                        data: JSON.stringify(task),
                        contentType: 'application/json',
                        success: function () {
                            $('#taskModal').modal('hide');
                            loadTasks();
                            showSuccessMessage('Successfully saved the task!');

                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            showErrorMessage('Error on saving task, Please try again!');
                            console.error('Error saving task:', textStatus, errorThrown);
                        }
                    });

                });

                window.editTask = function (id) {
                    debugger;
                    let userId = $('#hdnUserId').val();
                    let token = $('#hdnToken').val();
                    $.ajax({
                        url: `https://localhost:44397/api/tasks/${userId}/${id}`,
                        type: 'GET',
                        headers: {
                            'Authorization': 'Bearer ' + token
                        },
                        success: function (task) {
                            debugger;
                            $('#taskId').val(task.TaskId);
                            $('#taskName').val(task.TaskName);
                            $('#taskDescription').val(task.TaskDescription);
                            initDropdowns(task.UserId, task.StatusId);
                            $('#taskModal').modal('show');
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            showErrorMessage('Error on fetching task, Please try again!');
                            console.error('Error fetching task:', textStatus, errorThrown);
                        }
                    });
                    return false;
                }
           
                window.deleteTask = function (id) {
                    let userId = $('#hdnUserId').val();
                    let token = $('#hdnToken').val();
                    if (confirm('Are you sure you want to delete this task?')) {
                        $.ajax({
                            url: `https://localhost:44397/api/tasks/deleteTask/${userId}/${id}`,
                            type: 'DELETE',
                            headers: {
                                'Authorization': 'Bearer ' + token
                            },
                            success: function () {
                                loadTasks(true);
                                showSuccessMessage('Successfully deleted the task!');
                            },
                            error: function (jqXHR, textStatus, errorThrown) {
                                showErrorMessage('Error deleting task, Please try again!');
                                console.error('Error deleting task:', textStatus, errorThrown);
                            }
                        });
                    }
                }

                $('#exportBtn').click(function () {
                    let userId = $('#hdnUserId').val();
                    let token = $('#hdnToken').val();
                    $.ajax({
                        url: `https://localhost:44397/api/tasks/export/${userId}`,
                        type: 'GET',
                        xhrFields: {
                            responseType: 'blob'
                        },
                        headers: {
                            'Authorization': 'Bearer ' + token
                        },
                        success: function (data, status, xhr) {
                            var blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
                            var downloadUrl = URL.createObjectURL(blob);
                            var a = document.createElement('a');
                            var today = new Date();
                            a.href = downloadUrl;
                            a.download = 'Tasks_' + today.getSeconds().toString()
                                + today.getMinutes().toString()
                                + today.getHours().toString()
                                + today.getDate().toString()
                                + (today.getMonth() + 1)
                                + today.getFullYear() + '.xlsx';
                            document.body.appendChild(a);
                            a.click();
                            document.body.removeChild(a);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            showErrorMessage('Error exporting data, Please try again!');
                            console.error('Error exporting data:', textStatus, errorThrown);
                        }
                    });
                });

                function showSuccessMessage(message) {
                    $("#successText").text(message);
                    $("#successMessage").show();
                    setTimeout(function () {
                        $("#successMessage").hide();
                    }, 8000);
                }

                function showErrorMessage(message) {
                    $("#errorText").text(message);
                    $("#errorMessage").show();
                    setTimeout(function () {
                        $("#errorMessage").hide();
                    }, 8000);
                }

                window.loadTaskChart = function () {
                    let token = $('#hdnToken').val();
                    $.ajax({
                        url: 'https://localhost:44397/api/tasks/getTaskCountByUser',
                        type: 'GET',
                        headers: {
                            'Authorization': 'Bearer ' + token
                        },
                        success: function (data) {
                            renderChart(data);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            showErrorMessage('Error on fetching tasks for chart, Please try again!');
                            console.error('Error fetching tasks:', textStatus, errorThrown);
                        }
                    });
                }

                function renderChart(data) {
                    var users = data.map(function (item) {
                        return 'User ' + item.UserId;
                    });
                    var taskCounts = data.map(function (item) {
                        return item.TaskCount;
                    });

                    Highcharts.chart('taskChart', {
                        chart: {
                            type: 'column'
                        },
                        title: {
                            text: 'Number of Current Tasks Grouped by User'
                        },
                        xAxis: {
                            categories: users,
                            title: {
                                text: 'Users'
                            }
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: 'Number of Tasks'
                            }
                        },
                        series: [{
                            name: 'Tasks',
                            data: taskCounts
                        }]
                    });

                    $('#taskChart').show();
                }
            });
            function initDropdowns(userId,taskId) {

                let token = $('#hdnToken').val();
                $.ajax({
                    url: `https://localhost:44397/api/tasks/getalltaskstatus`, 
                    type: 'GET',
                    headers: {
                        'Authorization': 'Bearer ' + token
                    },
                    success: function (statuses) {
                        let statusDropdown = $('#taskStatus');
                        statusDropdown.empty();
                        $.each(statuses, function (index, status) {
                            statusDropdown.append($('<option></option>').val(status.StatusId).text(status.StatusName));
                        });
                        statusDropdown.val(taskId)

                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        showErrorMessage('Error on fetching task statuses, Please try again!');
                        console.error('Error fetching task statuses:', textStatus, errorThrown);
                    }
                });

                $.ajax({
                    url: `https://localhost:44397/api/account/getallusers`,
                    type: 'GET',
                    headers: {
                        'Authorization': 'Bearer ' + token
                    },
                    success: function (users) {
                        let userDropdown = $('#assignUser');
                        userDropdown.empty();
                        $.each(users, function (index, user) {
                            userDropdown.append($('<option></option>').val(user.UserId).text(user.FullName));
                        });
                        userDropdown.val(userId);
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        showErrorMessage('Error on fetching users, Please try again!');
                        console.error('Error fetching users:', textStatus, errorThrown);
                    }
                });
            }
      
    </script>
    </asp:PlaceHolder>
</asp:Content>
