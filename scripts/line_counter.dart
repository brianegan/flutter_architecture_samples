import 'dart:io';

class Sample {
  final String name;
  final List<Directory> directories;

  Sample(this.name, List<String> paths)
      : directories = paths.map((path) => Directory('$path/lib')).toList();
}

class Output {
  final String name;
  final int lineCount;

  Output(this.name, this.lineCount);

  @override
  String toString() {
    return 'Output{name: $name, lineCount: $lineCount}';
  }
}

void main() {
  final samples = [
    Sample('change_notifier_provider', ['change_notifier_provider']),
    Sample('bloc', ['bloc_flutter', 'blocs']),
    Sample('bloc library', ['bloc_library']),
    Sample('built_redux', ['built_redux']),
    Sample('firestore_redux', ['firestore_redux']),
    Sample('frideos_library', ['frideos_library']),
    Sample('inherited_widget', ['inherited_widget']),
    Sample('mobx', ['mobx']),
    Sample('mvc', ['mvc']),
    Sample('mvi', ['mvi_flutter', 'mvi_base']),
    Sample('mvu', ['mvu']),
    Sample('redux', ['redux']),
    Sample('scoped_model', ['scoped_model']),
    Sample('simple blocs', ['simple_bloc_flutter', 'simple_blocs']),
    Sample('vanilla', ['vanilla']),
  ];
  final outputs = samples.map<Output>((sample) {
    return Output(
      sample.name,
      _countLines(sample.directories),
    );
  }).toList(growable: false)
    ..sort((a, b) => a.lineCount - b.lineCount);

  final strings = outputs
      .map<String>((output) => '| ${output.name} | ${output.lineCount} |')
      .join('\n');

  print('''
# Line Counts

Though not the only factor or even most important factor, the amount of code it
takes to achieve a working product is an important consideration when comparing
frameworks.

This is an imperfect line count comparison -- some of the samples contain a bit
more functionality / are structured a bit differently than others -- and should
be taken with a grain of salt. All generated files, blank lines and comment 
lines are removed for this comparison.

For authors of frameworks or samples (hey, I'm one of those!): Please do not 
take this comparison personally, nor should folks play "Code Golf" with the
samples to make them smaller, unless doing so improves the application overall.  
  
| *Sample* | *LOC (no comments)* |
|--------|-------------------|
$strings

Note: This file was generated on ${DateTime.now().toUtc()} using `scripts/line_counter.dart`.  
''');
}

int _countLines(List<Directory> directories) {
  final dartFiles = _findDartFiles(directories);

  return dartFiles.fold(0, (count, file) {
    final nonCommentsLineCount = file
        .readAsLinesSync()
        .where((line) => !line.startsWith('//') && line.trim().isNotEmpty)
        .length;

    return count + nonCommentsLineCount;
  });
}

List<File> _findDartFiles(List<Directory> directories) {
  final paths = directories.fold(<String>{}, (files, directory) {
    final currentDirectoryDartFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.path)
        .where((path) =>
            path.endsWith('.dart') &&
            !path.endsWith('.g.dart') &&
            !path.contains('todos_repository') &&
            !path.contains('file_storage') &&
            !path.contains('web_client') &&
            !path.contains('main_'))
        .toSet();

    return {...files, ...currentDirectoryDartFiles};
  });

  return List.unmodifiable(paths.map<File>((path) => File(path)));
}
