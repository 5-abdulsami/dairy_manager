// lib/modules/backup/backup_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dairy_manager/modules/backup/backup_controller.dart';

class BackupView extends GetView<BackupController> {
  const BackupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Backup & Restore')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildBackupSection(),
              SizedBox(height: 20),
              _buildRestoreSection(),
              SizedBox(height: 20),
              _buildInfoSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackupSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.backup, size: 48, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'Create Backup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Save all your data to a backup file. You can choose where to save it.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 15),
            Obx(
              () =>
                  controller.isExporting.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: controller.exportBackup,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Create Backup'),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.restore, size: 48, color: Colors.orange),
            SizedBox(height: 10),
            Text(
              'Restore Backup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Restore your data from a backup file. This will replace all current data.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 15),
            Obx(
              () =>
                  controller.isImporting.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () => _showRestoreDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Restore from Backup'),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              'Important Information',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 5),
            Text(
              '• Backup files are saved as JSON\n'
              '• You can choose any location to save\n'
              '• Restoring will replace ALL current data\n'
              '• Make regular backups to avoid data loss',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showRestoreDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Restore Backup'),
        content: Text(
          'WARNING: This will replace ALL current data with the backup data. This action cannot be undone. Are you sure?',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.importBackup();
            },
            child: Text('Restore', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
