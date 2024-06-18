<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/Site.Master" AutoEventWireup="true" CodeBehind="TaskManager.aspx.cs" Inherits="TaskManagementUI.Pages.TaskManager" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <h2>Task Manager</h2>
        <div class="form-row">
            <div class="ml-auto mt-3">
                <button id="addnewBtn" type="button" class="btn btn-primary m-3" data-toggle="modal" data-target="#taskModal">
                    <i class="fas fa-plus-circle mr-1"></i>Add Task</button>
                <button id="exportBtn" type="button" class="btn btn-success m-3">
                    <i class="fas fa-file-excel mr-2"></i>Export to Excel
                </button>
            </div>
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
            </tbody>
        </table>
    </div>
    <div class="container mt-5">
        <div id="taskChart" class="w-100 d-none mt-3 h-25"></div>
    </div>

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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal"> <i class="fas fa-times-circle mr-1"></i> Close</button>
                    <button type="button" class="btn btn-primary" id="saveTaskButton"><i class="fas fa-save mr-1"></i> Save</button>
                </div>
            </div>
        </div>
    </div>

    <asp:PlaceHolder runat="server">
        <script>
            $(document).ready(() => new TaskManager());

    </script>
    </asp:PlaceHolder>
</asp:Content>
