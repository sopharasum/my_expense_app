import 'package:expense_app/config/constance.dart';
import 'package:expense_app/domain/entities/faq.dart';
import 'package:expense_app/presentation/faq/faq_view_model.dart';
import 'package:expense_app/presentation/widget/custom_empty_container.dart';
import 'package:expense_app/presentation/widget/custom_loading.dart';
import 'package:expense_app/presentation/widget/custom_text.dart';
import 'package:expense_app/util/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqDataSection extends StatelessWidget {
  final FAQViewModel viewModel;

  FaqDataSection(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async => viewModel.reload(),
        child: CustomScrollView(
          controller: viewModel.scroll,
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _faqItem(context, viewModel.faqs[index]),
                  childCount: viewModel.faqs.length,
                ),
              ),
            ),
            viewModel.queryStatus == DataStatus.QUERY_MORE
                ? CustomLoading()
                : CustomEmptyContainer()
          ],
        ),
      ),
    );
  }

  Widget _faqItem(BuildContext context, Faq faq) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        title: CustomText(
          text: viewModel.language == "en"
              ? faq.faqQuestionEn
              : faq.faqQuestionKh,
          fontSize: 15,
          color: Colors.red,
        ),
        children: <Widget>[
          ListTile(
            title: CustomText(
              text: viewModel.language == "en"
                  ? faq.faqAnswerEn
                  : faq.faqAnswerKh,
            ),
          ),
          if (faq.faqLink != null && faq.faqLink?.isNotEmpty == true)
            ListTile(
              title: Text.rich(
                TextSpan(
                  text: "label_faq_video".tr,
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchURL(context, "${faq.faqLink}"),
                      text: faq.faqLink,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
                style: TextStyle(fontSize: 14),
              ),
            )
        ],
      ),
    );
  }
}
