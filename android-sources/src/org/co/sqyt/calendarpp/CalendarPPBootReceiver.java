package org.co.sqyt.calendarpp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class CalendarPPBootReceiver extends BroadcastReceiver {

    public CalendarPPBootReceiver() {

    }

    public void onReceive(Context context, Intent intent) {
        Intent i = new Intent(context, CalendarPPService.class);
        context.startService(i);
    }
}
