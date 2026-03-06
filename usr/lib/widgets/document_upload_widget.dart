import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DocumentUploadWidget extends StatefulWidget {
  final String recordId;
  final String recordType; // 'SPO' or 'COP'

  const DocumentUploadWidget({super.key, required this.recordId, required this.recordType});

  @override
  State&lt;DocumentUploadWidget&gt; createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State&lt;DocumentUploadWidget&gt; {
  final List&lt;String&gt; _uploadedFiles = [];

  Future&lt;void&gt; _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx', 'xls'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _uploadedFiles.addAll(result.files.map((file) => file.name));
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.files.length} file(s) uploaded successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Documents for ${widget.recordType} ${widget.recordId}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Upload'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_uploadedFiles.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _uploadedFiles.map((fileName) {
              final extension = fileName.split('.').last.toLowerCase();
              IconData icon;
              switch (extension) {
                case 'pdf':
                  icon = Icons.picture_as_pdf;
                  break;
                case 'xlsx':
                case 'xls':
                  icon = Icons.table_chart;
                  break;
                default:
                  icon = Icons.insert_drive_file;
              }
              
              return Chip(
                avatar: Icon(icon, size: 18),
                label: Text(fileName),
                onDeleted: () {
                  setState(() {
                    _uploadedFiles.remove(fileName);
                  });
                },
              );
            }).toList(),
          )
        else
          const Text('No documents uploaded yet'),
      ],
    );
  }
}