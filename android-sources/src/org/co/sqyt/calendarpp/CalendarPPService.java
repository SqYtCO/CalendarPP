package org.co.sqyt.calendarpp;

import org.qtproject.qt5.android.bindings.QtService;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.app.PendingIntent;
import android.content.Intent;
import android.app.AlarmManager;
import java.util.Calendar;
import android.util.Log;
import java.util.Date;

public class CalendarPPService extends QtService {

    static private NotificationManager notificationManager;
    static private Notification.Builder builder;
    static private int notificationNr;
    static private AlarmManager timer;
    static private PendingIntent alarmIntent;
    static private CalendarPPService instance;

    public CalendarPPService() {
        notificationNr = 0;
        instance = this;
    }

    public static String getDirOfData(Context context) {
        return context.getFilesDir().toString() + "/";
    }

    private static native String checkNext(String path);
    /* returns a String with next reminder(s)
     * 1. Name
     * 2. Description
     * 3. Starttime
     * 4. Time of reminder
     * 5. Time to start
    */

    static {
        System.loadLibrary("Calendar++");                       // libCalendar++.so
    }

    public void onCreate() {
        remind(this);
    }

    public void notify(String title, String notification) {
    //    CalendarPPActivity.notify(title, notification);

        if (notificationManager == null) {
            notificationManager = (NotificationManager)getSystemService(Context.NOTIFICATION_SERVICE);
            builder = new Notification.Builder(this);
            builder.setSmallIcon(R.drawable.round_icon);
//          builder.setOngoing(true);
        }

        builder.setContentTitle(title);
        builder.setContentText(notification);
        notificationManager.notify(++notificationNr, builder.build());
    }

    public static void notify(String title, String notification, Context context) {
        if (notificationManager == null) {
            notificationManager = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
            builder = new Notification.Builder(context);
            builder.setSmallIcon(R.drawable.round_icon);
//          builder.setOngoing(true);
        }

        builder.setContentTitle(title);
        builder.setContentText(notification);
        notificationManager.notify(++notificationNr, builder.build());
    }

    private static void setupAlarm(Calendar calendar, Context context) {
        timer = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, CalendarPPAlarmReceiver.class);
        alarmIntent = PendingIntent.getBroadcast(context, 0, intent, 0);

        timer.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), alarmIntent);
    }

    public static void remind(Context context) {
        String str = checkNext(getDirOfData(context));
        String[] pars = str.split("\t");

    //    if(pars[0].length > 0) {
        for(String s : pars)
            Log.i("CalendarPP++", s + ";");

        for(int i = 0; i < pars.length/5; ++i) {
            notify(pars[0 + i * 5], setupNotification(pars[0 + i * 5], pars[1 + i * 5], Integer.parseInt(pars[4 + i * 5]), pars[2 + i * 5]), context);
            String[] dateArray = pars[3].split("-");
            int year = Integer.parseInt(dateArray[0]);
            int month = Integer.parseInt(dateArray[1]);
            int day = Integer.parseInt(dateArray[2]);
            int hour = Integer.parseInt(dateArray[3]);
            int min = Integer.parseInt(dateArray[4]);

            Calendar calendar = Calendar.getInstance();
            calendar.set(year, month - 1, day, hour, min);
            calendar.set(Calendar.SECOND, 0);
            setupAlarm(calendar, context);
        }
    }

    public static String setupNotification(String name, String description, int timeToStart, String startTime) {    // change String startTime to Calendar for formatting
        if(timeToStart != 0)
            return name + " starts in " + timeToStart + " minutes at " + startTime;
        else
            return name + " starts now at " + startTime;
    }
}
