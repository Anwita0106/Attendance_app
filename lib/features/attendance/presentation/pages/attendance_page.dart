import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/attendance.dart';
import '../bloc/attendance_bloc.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AttendanceBloc>()..add(LoadAttendanceToday()),
      child: const AttendanceView(),
    );
  }
}

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Attendance'),
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AttendanceBloc>().add(LoadAllAttendance());
            },
          ),
          IconButton(
            icon: const Icon(Icons.today_outlined),
            onPressed: () {
              context.read<AttendanceBloc>().add(LoadAttendanceToday());
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttendanceLoaded) {
              final presentCount = state.attendanceList
                  .where((a) => a.status == 'Present')
                  .length;
              final absentCount = state.attendanceList
                  .where((a) => a.status == 'Absent')
                  .length;
              final halfDayCount = state.attendanceList
                  .where((a) => a.status == 'Half-day')
                  .length;

              return Column(
                children: [
                  _StatisticsCard(
                    present: presentCount,
                    absent: absentCount,
                    halfDay: halfDayCount,
                    total: state.attendanceList.length,
                  ),
                  Expanded(
                    child: state.attendanceList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.event_note,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'No records found',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.attendanceList.length,
                            itemBuilder: (context, index) {
                              final attendance = state.attendanceList[index];
                              return _AttendanceCard(attendance: attendance);
                            },
                          ),
                  ),
                ],
              );
            } else if (state is AttendanceError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAttendanceDialog(context),
        label: const Text('Check In/Out'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddAttendanceDialog(BuildContext context) {
    final remarksController = TextEditingController();
    String status = 'Present'; // Default
    // Time defaults to now

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Attendance'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: status,
                  isExpanded: true,
                  items: ['Present', 'Absent', 'Half-day', 'Leave']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => status = val);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: remarksController,
                  decoration:
                      const InputDecoration(labelText: 'Remarks (Optional)'),
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final attendance = Attendance(
                  date: DateTime.now(),
                  status: status,
                  checkInTime: DateTime
                      .now(), // Simplified: recording 'Add' time as check-in
                  remarks: remarksController.text,
                );
                // Accessing the bloc from the parent context provided by BlocProvider
                context
                    .read<AttendanceBloc>()
                    .add(AddAttendanceEvent(attendance));
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _StatisticsCard extends StatelessWidget {
  final int present;
  final int absent;
  final int halfDay;
  final int total;

  const _StatisticsCard({
    required this.present,
    required this.absent,
    required this.halfDay,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                    label: 'Present', count: present, color: Colors.green),
                _StatItem(label: 'Absent', count: absent, color: Colors.red),
                _StatItem(
                    label: 'Half-day', count: halfDay, color: Colors.orange),
              ],
            ),
            const Divider(),
            Text('Total Records: $total'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final Attendance attendance;
  const _AttendanceCard({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    Color statusColor;
    Color statusBgColor;
    switch (attendance.status) {
      case 'Present':
        statusColor = Colors.green[800]!;
        statusBgColor = Colors.green[100]!;
        break;
      case 'Absent':
        statusColor = Colors.red[800]!;
        statusBgColor = Colors.red[100]!;
        break;
      case 'Half-day':
        statusColor = Colors.orange[800]!;
        statusBgColor = Colors.orange[100]!;
        break;
      default:
        statusColor = Colors.grey[800]!;
        statusBgColor = Colors.grey[200]!;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      dateFormat.format(attendance.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    attendance.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (attendance.checkInTime != null ||
                (attendance.remarks != null &&
                    attendance.remarks!.isNotEmpty)) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (attendance.checkInTime != null)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            timeFormat.format(attendance.checkInTime!),
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  if (attendance.remarks != null &&
                      attendance.remarks!.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.note, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              attendance.remarks!,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
