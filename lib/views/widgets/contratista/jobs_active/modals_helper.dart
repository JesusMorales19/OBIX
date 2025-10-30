import 'package:flutter/material.dart';
import 'confirm_end_job_modal.dart';
import 'rate_employees_modal.dart';

void showEndJobFlow(BuildContext context, List<String> employees) {
  showDialog(
    context: context,
    builder: (_) => ConfirmEndJobModal(
      onConfirm: () {
        showDialog(
          context: context,
          builder: (_) => RateEmployeesModal(employees: employees),
        );
      },
    ),
  );
}
