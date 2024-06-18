class TaskManager {
    constructor() {
        this.userId = $('#hdnUserId').val();
        this.token = $('#hdnToken').val();
        this.baseUrl = $('#hdnBaseUrl').val() + 'api/tasks/';
        this.baseUrlAccount = $('#hdnBaseUrl').val() + 'api/account/';
        this.init();
    }

    init() {
        this.loadTasks(true);
        $('#addnewBtn').click(() => this.resetTaskForm());
        $('#saveTaskButton').click(() => this.saveTask());
        $('#exportBtn').click(() => this.exportTasks());
        window.editTask = (id) => this.editTask(id);
        window.deleteTask = (id) => this.deleteTask(id);
        window.loadTaskChart = () => this.loadTaskChart();
    }

    loadTasks(reloadChart) {
        $.ajax({
            url: `${this.baseUrl}/${this.userId}`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + this.token },
            success: (tasks) => this.renderTaskTable(tasks, reloadChart),
            error: (jqXHR, textStatus, errorThrown) => this.showErrorMessage('Error fetching tasks, Please try again!')
        });
    }

    renderTaskTable(tasks, reloadChart) {
        const taskTableBody = $('#taskTableBody');
        taskTableBody.empty();
        tasks.forEach(task => {
            const row = `
                <tr>
                    <td>${task.TaskId}</td>
                    <td>${task.TaskName}</td>
                    <td>${task.AssignTo}</td>
                    <td>${task.StatusName}</td>
                    <td>${task.TaskDescription}</td>
                    <td>
                        <button class="btn btn-warning btn-sm" type="button" onclick="editTask(${task.TaskId})"><i class="fas fa-edit"></i> Edit</button>
                        <button class="btn btn-danger btn-sm" type="button" onclick="deleteTask(${task.TaskId})"><i class="fas fa-trash-alt"></i> Delete</button>
                    </td>
                </tr>`;
            taskTableBody.append(row);
        });
        if (reloadChart) setTimeout(() => this.loadTaskChart(), 3000);
    }

    resetTaskForm() {
        $('#taskId').val('');
        $('#taskName').val('');
        $('#taskDescription').val('');
        $('#taskName').removeClass('is-invalid');
        $('#taskDescription').removeClass('is-invalid');
        this.initDropdowns(this.userId, 1);
    }

    saveTask() {
        const taskName = $('#taskName').val().trim();
        const taskDescription = $('#taskDescription').val().trim();
        if (!taskName) {
            $('#taskName').addClass('is-invalid');
            return;
        }
        if (!taskDescription) {
            $('#taskDescription').addClass('is-invalid');
            return;
        }
        $('#taskName').removeClass('is-invalid');
        $('#taskDescription').removeClass('is-invalid');

        const task = {
            TaskId: $('#taskId').val(),
            TaskName: taskName,
            TaskDescription: taskDescription,
            UserId: $('#assignUser').val(),
            StatusId: $('#taskStatus').val(),
            CreatedById: this.userId,
            LastUpdatedByUserId: this.userId
        };

        const method = task.TaskId ? 'PUT' : 'POST';
        const endpoint = task.TaskId ? 'updateTask' : 'createTask';

        $.ajax({
            url: `${this.baseUrl}/${endpoint}`,
            type: method,
            headers: { 'Authorization': 'Bearer ' + this.token },
            data: JSON.stringify(task),
            contentType: 'application/json',
            success: () => {
                $('#taskModal').modal('hide');
                this.loadTasks(true);
                CommonJs.showSuccessMessage('Successfully saved the task!');
            },
            error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error saving task, Please try again!')
        });
    }

    editTask(id) {
        $.ajax({
            url: `${this.baseUrl}/${this.userId}/${id}`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + this.token },
            success: (task) => {
                $('#taskId').val(task.TaskId);
                $('#taskName').val(task.TaskName);
                $('#taskDescription').val(task.TaskDescription);
                this.initDropdowns(task.UserId, task.StatusId);
                $('#taskModal').modal('show');
            },
            error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error fetching task, Please try again!')
        });
        return false;
    }

    deleteTask(id) {
        if (confirm('Are you sure you want to delete this task?')) {
            $.ajax({
                url: `${this.baseUrl}/deleteTask/${this.userId}/${id}`,
                type: 'DELETE',
                headers: { 'Authorization': 'Bearer ' + this.token },
                success: () => {
                    this.loadTasks(true);
                    CommonJs.showSuccessMessage('Successfully deleted the task!');
                },
                error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error deleting task, Please try again!')
            });
        }
    }

    exportTasks() {
        $.ajax({
            url: `${this.baseUrl}/export/${this.userId}`,
            type: 'GET',
            xhrFields: { responseType: 'blob' },
            headers: { 'Authorization': 'Bearer ' + this.token },
            success: (data, status, xhr) => this.downloadExportedTasks(data),
            error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error exporting data, Please try again!')
        });
    }

    downloadExportedTasks(data) {
        const blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
        const downloadUrl = URL.createObjectURL(blob);
        const a = document.createElement('a');
        const today = new Date();
        a.href = downloadUrl;
        a.download = `Tasks_${today.getSeconds()}${today.getMinutes()}${today.getHours()}${today.getDate()}${today.getMonth() + 1}${today.getFullYear()}.xlsx`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    }

    loadTaskChart() {
        $.ajax({
            url: `${this.baseUrl}/getTaskCountByUser`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + this.token },
            success: (data) => this.renderChart(data),
            error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error fetching tasks for chart, Please try again!')
        });
    }

    renderChart(data) {
        const users = data.map(item => item.FullName);
        const taskCounts = data.map(item => item.TaskCount);
        Highcharts.chart('taskChart', {
            chart: { type: 'column' },
            title: { text: 'Number of Current Tasks Grouped by User' },
            xAxis: { categories: users, title: { text: 'Users' } },
            yAxis: { min: 0, title: { text: 'Number of Tasks' } },
            series: [{ name: 'Tasks', data: taskCounts }],
            exporting: {enabled: true,buttons: {contextButton: {menuItems: ['downloadPNG', 'downloadJPEG', 'downloadPDF', 'downloadSVG']}}}
        });
        $('#taskChart').removeClass('d-none');
    }

    initDropdowns(userId, taskId) {
        $.ajax({
            url: `${this.baseUrl}/getalltaskstatus`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + this.token },
            success: (statuses) => this.populateStatusDropdown(statuses, taskId),
            error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error fetching task statuses, Please try again!')
        });

        $.ajax({
            url: `${this.baseUrlAccount}/getallusers`,
            type: 'GET',
            headers: { 'Authorization': 'Bearer ' + this.token },
            success: (users) => this.populateUserDropdown(users, userId),
            error: (jqXHR, textStatus, errorThrown) => CommonJs.showErrorMessage('Error fetching users, Please try again!')
        });
    }

    populateStatusDropdown(statuses, taskId) {
        const statusDropdown = $('#taskStatus');
        statusDropdown.empty();
        statuses.forEach(status => {
            statusDropdown.append($('<option></option>').val(status.StatusId).text(status.StatusName));
        });
        statusDropdown.val(taskId);
    }

    populateUserDropdown(users, userId) {
        const userDropdown = $('#assignUser');
        userDropdown.empty();
        users.forEach(user => {
            userDropdown.append($('<option></option>').val(user.UserId).text(user.FullName));
        });
        userDropdown.val(userId);
    }
    
}


