class Worker {
  String? workerId;
  String? workerName;
  String? workerEmail;
  String? workerPassword;
  String? workerPhone;
  String? workerAddress;

  Worker(
      {this.workerId,
      this.workerName,
      this.workerEmail,
      this.workerPassword,
      this.workerPhone,
      this.workerAddress});

  Worker.fromJson(Map<String, dynamic> json) {
    workerId = json['worker_id'];
    workerName = json['worker_name'];
    workerEmail = json['worker_email'];
    workerPassword = json['worker_password'];
    workerPhone = json['worker_phone'];
    workerAddress = json['worker_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['worker_id'] = workerId;
    data['worker_name'] = workerName;
    data['worker_email'] = workerEmail;
    data['worker_password'] = workerPassword;
    data['worker_phone'] = workerPhone;
    data['worker_address'] = workerAddress;
    return data;
  }
}