package org.co.sqyt.calendarpp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class CalendarPPAlarmReceiver extends BroadcastReceiver {

    public CalendarPPAlarmReceiver() {

    }

    public void onReceive(Context context, Intent intent) {
        CalendarPPService.remind(context.getApplicationContext());
    }
}
