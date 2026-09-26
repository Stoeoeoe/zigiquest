package ch.zigiquest.zigi_quest

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class ZigiQuickAddWideWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray, data: SharedPreferences) {
    ids.forEach { id ->
      val views = RemoteViews(context.packageName, R.layout.zigi_quick_add_wide_widget)
      val isCleanup = data.getBoolean("zigi_widget_cleanup_active", false)
      views.setTextViewText(R.id.widget_title, context.getString(if (isCleanup) R.string.widget_cleanup else R.string.widget_today))
      views.setTextViewText(R.id.widget_count, data.getInt("zigi_widget_count", 0).toString())
      views.setTextViewText(R.id.widget_target, context.getString(if (isCleanup) R.string.widget_cleanup_target else R.string.widget_today_target))
      views.setOnClickPendingIntent(R.id.widget_root, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java))
      views.setOnClickPendingIntent(R.id.widget_add, HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("zigiquest://widget/add")))
      manager.updateAppWidget(id, views)
    }
  }
}