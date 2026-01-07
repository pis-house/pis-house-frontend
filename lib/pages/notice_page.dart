import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/notification_repository.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';
import 'package:pis_house_frontend/utils/date_extension.dart';

class NoticePage extends HookConsumerWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);
    final notificationRepository = ref.watch(notificationRepositoryProvider);
    final noticeFuture = notificationRepository.getByTenantId(
      authService.user!.tenantId,
    );

    return FutureBuilder<List<NotificationModel>>(
      future: noticeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('不明なエラーが発生しました')));
        }

        final goingHomeNotice = (snapshot.data ?? [])
            .where((notice) => notice.type == "going_home")
            .toList();
        final goingOutNotice = (snapshot.data ?? [])
            .where((notice) => notice.type == "going_out")
            .toList();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PisBaseHeader(title: "通知一覧"),
            body: Column(
              children: [
                Container(
                  color: theme.brightness == Brightness.light
                      ? theme.colorScheme.primary
                      : null,
                  width: double.infinity,
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(fontSize: 18.0),
                    tabs: const [
                      Tab(text: "帰宅"),
                      Tab(text: "外出"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildNoticeList(goingHomeNotice, "帰宅"),
                      _buildNoticeList(goingOutNotice, "外出"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoticeList(List<NotificationModel> notices, String typeLabel) {
    if (notices.isEmpty) {
      return Center(
        child: Text(
          "$typeLabelの通知はありません",
          style: const TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      itemCount: notices.length,
      itemBuilder: (context, index) {
        final notice = notices[index];
        final theme = Theme.of(context);

        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
                width: 1.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: theme.disabledColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notice.createdAt.toJapaneseFormat(),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: theme.disabledColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
