package feature.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class DateTimeTool {

    private final static String DEFAULT_DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ssXXX";

    /**
     * @param dateTime takes a date string as input and validates it against the RFC3339 format
     * @return true if the format is correct
     */
    public static boolean isRFC3339DateTimeFormat(String dateTime) {
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ISO_DATE_TIME;
            formatter.parse(dateTime);
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    /**
     * @param datetime takes a datetime string as input
     * @param format date format
     * @return true if the format is correct
     */
    public static boolean isValidDateTime(String datetime, String format) {
        try {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
            formatter.parse(datetime);
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    /**
     * Generates a date/datetime in certain format
     * @return string with the date in certain date/datetime format
     */
    public static String getFormatDate(String format, int daysToAdd) {
        LocalDateTime currentDate = LocalDateTime.now();
        LocalDateTime futureDate = currentDate.plusDays(daysToAdd);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
        return futureDate.format(formatter);
    }

    public static String getFormatDate(int daysToAdd) {
        String format = DEFAULT_DATE_TIME_FORMAT;
        LocalDateTime currentDate = LocalDateTime.now();
        LocalDateTime futureDate = currentDate.plusDays(daysToAdd);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(format);
        return futureDate.format(formatter);
    }

}
