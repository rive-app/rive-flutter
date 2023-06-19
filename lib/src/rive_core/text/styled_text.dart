import 'package:rive_common/rive_text.dart';
import 'package:rive_common/utilities.dart';

/// To allow the text editor to see the cursor placed in a location prior to
/// text entry (like pressing return) we need to introduce a place-holder last
/// character.
const zeroWidthSpace = '\u200B';

class StyledText {
  final String value;
  final List<TextRun> runs;

  factory StyledText(String text, List<TextRun> runs) {
    assert(runs.isNotEmpty);

    var extendedRuns = runs.take(runs.length - 1).toList();
    extendedRuns
        .add(runs.last.copyWith(unicharCount: runs.last.unicharCount + 1));
    return StyledText.exact(text + zeroWidthSpace, extendedRuns);
  }

  factory StyledText.empty(TextRun run) => StyledText('', [run]);

  StyledText withoutLastCharacter() {
    assert(value.isNotEmpty);
    var shortenedRuns = runs.take(runs.length - 1).toList();
    if (runs.last.unicharCount > 1) {
      // Only add the last run if it's not 0 length.
      shortenedRuns
          .add(runs.last.copyWith(unicharCount: runs.last.unicharCount - 1));
    }
    return StyledText.exact(
        value.substring(0, value.length - 1), shortenedRuns);
  }

  StyledText.exact(this.value, this.runs);

  @override
  bool operator ==(Object other) =>
      other is StyledText &&
      other.value == value &&
      iterableEquals(other.runs, runs);

  @override
  int get hashCode => Object.hash(value, Object.hashAll(runs));
}
