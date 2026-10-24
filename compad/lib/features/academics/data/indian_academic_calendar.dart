class AcademicHoliday {
  final String title;
  final DateTime date;
  final bool isNationalHoliday; // Gazetted national holiday (fixed)
  final String description;

  const AcademicHoliday({
    required this.title,
    required this.date,
    required this.isNationalHoliday,
    required this.description,
  });
}

class IndianAcademicCalendar {
  /// Three statutory national gazetted holidays observed across all Indian educational institutions
  static List<AcademicHoliday> getNationalHolidays(int year) {
    return [
      AcademicHoliday(
        title: 'Republic Day',
        date: DateTime(year, 1, 26),
        isNationalHoliday: true,
        description: 'Commemoration of the Constitution of India coming into effect (26 January 1950).',
      ),
      AcademicHoliday(
        title: 'Independence Day',
        date: DateTime(year, 8, 15),
        isNationalHoliday: true,
        description: 'National commemoration of Indian Independence (15 August 1947).',
      ),
      AcademicHoliday(
        title: 'Mahatma Gandhi Jayanti',
        date: DateTime(year, 10, 2),
        isNationalHoliday: true,
        description: 'Birth anniversary of Mohandas Karamchand Gandhi (National Holiday).',
      ),
    ];
  }

  /// Default Indian semester date windows (fully user and campus-pack editable)
  static Map<String, dynamic> getDefaultSemesterDates(int academicYearStart) {
    return {
      'academicYear': '$academicYearStart-${(academicYearStart + 1) % 100}',
      'oddSemester': {
        'name': 'Odd Semester (Monsoon)',
        'startDate': DateTime(academicYearStart, 7, 20),
        'midSemDate': DateTime(academicYearStart, 9, 25),
        'endDate': DateTime(academicYearStart, 12, 10),
      },
      'evenSemester': {
        'name': 'Even Semester (Spring)',
        'startDate': DateTime(academicYearStart + 1, 1, 15),
        'midSemDate': DateTime(academicYearStart + 1, 3, 20),
        'endDate': DateTime(academicYearStart + 1, 5, 25),
      },
    };
  }
}
