class Submission {
  String? submissionId;
  String? taskTitle;
  String? submittedAt;
  String? submissionPreview;

  Submission({
    this.submissionId,
    this.taskTitle,
    this.submittedAt,
    this.submissionPreview,
  });

  Submission.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    taskTitle = json['task_title'];
    submittedAt = json['submitted_at'];
    submissionPreview = json['submission_preview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['submission_id'] = submissionId;
    data['task_title'] = taskTitle;
    data['submitted_at'] = submittedAt;
    data['submission_preview'] = submissionPreview;
    return data;
  }
}
