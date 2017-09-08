package org.co.sqyt.calendarpp;

import org.qtproject.qt5.android.bindings.QtActivity;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.Context;

import android.util.Log;

public class CalendarPPActivity extends QtActivity {
    private static NotificationManager notificationManager;
    private static Notification.Builder builder;
    private static CalendarPPActivity instance;
    private static int notificationNr;

    public CalendarPPActivity() {
        instance = this;
        notificationNr = 0;
    }

    public static void notify(String title, String notification) {
        if (notificationManager == null) {
            notificationManager = (NotificationManager)instance.getSystemService(Context.NOTIFICATION_SERVICE);
            builder = new Notification.Builder(instance);
            builder.setSmallIcon(R.drawable.round_icon);
        }

        builder.setContentTitle(title);
        builder.setContentText(notification);
        notificationManager.notify(++notificationNr, builder.build());
    }

    public static void updateService() {
        Log.i("CalendarPP++", "Start update service from Java");
     //   Intent intent = new Intent(instance, CalendarPPAlarmReceiver.class);
     //   PendingIntent alarmIntent = PendingIntent.getBroadcast(instance, 0, intent, 0);
        CalendarPPService.remind(instance);

    }
}
