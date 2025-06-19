class Task {
  String? title;
  String? description;
  String? dueDate;
  String? status;
  String? workerId;
  String? taskId;

  Task(
    {
      this.title, 
      this.description, 
      this.dueDate, 
      this.status,
      this.workerId,
      this.taskId,
    });

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    dueDate = json['due_date'];
    status = json['status'];
    workerId = json['assigned_to'];
    taskId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    data['due_date'] = dueDate;
    data['status'] = status;
    data['assigned_to'] = workerId;
    data['id'] = taskId;
    return data;
  }
}
