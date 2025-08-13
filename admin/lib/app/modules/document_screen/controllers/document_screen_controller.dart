import 'package:admin/app/constant/collection_name.dart';
import 'package:admin/app/constant/constants.dart';
import 'package:admin/app/constant/show_toast.dart';
import 'package:admin/app/models/documents_model.dart';
import 'package:admin/app/modules/document_screen/views/document_screen_view.dart';
import 'package:admin/app/utils/fire_store_utils.dart';
import 'package:admin/app/utils/toast.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentScreenController extends GetxController {
  RxString title = "Document".tr.obs;

  Rx<TextEditingController> documentNameController = TextEditingController().obs;
  Rx<SideAt> documentSide = SideAt.isOneSide.obs;
  RxBool isEditing = false.obs;
  RxBool isLoading = false.obs;
  RxBool isActive = false.obs;
  Rx<String> editingId = "".obs;
  RxList<DocumentsModel> documentsList = <DocumentsModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      isLoading.value = true;
      documentsList.clear();
      final data = await FireStoreUtils.getDocument();
      if (data.isNotEmpty) {
        documentsList.addAll(data);
      }
    } catch (e) {
      ShowToast.errorToast('Failed to load documents');
    } finally {
      isLoading.value = false;
    }
  }

  void setDefaultData() {
    documentNameController.value.clear();
    editingId.value = "";
    documentSide.value = SideAt.isOneSide;
    isActive.value = false;
    isEditing.value = false;
  }

  Future<void> updateDocument() async {
    isEditing = true.obs;
    await FireStoreUtils.addDocument(DocumentsModel(
        id: editingId.value,
        isEnable: isActive.value,
        isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false,
        title: documentNameController.value.text));
    await fetchDocuments();
    isEditing = false.obs;
  }

  Future<void> addDocument() async {
    isLoading = true.obs;
    await FireStoreUtils.addDocument(DocumentsModel(
        id: Constant.getRandomString(20),
        isEnable: isActive.value,
        isTwoSide: documentSide.value == SideAt.isTwoSide ? true : false,
        title: documentNameController.value.text));
    await fetchDocuments();
    isLoading = false.obs;
  }

  Future<void> removeDocument(DocumentsModel documentsModel) async {
    isLoading = true.obs;

    await FirebaseFirestore.instance.collection(CollectionName.documents).doc(documentsModel.id).delete().then((value) {
      ShowToastDialog.toast("Document deleted...!".tr);
    }).catchError((error) {
      ShowToastDialog.toast("Something went wrong".tr);
    });
    await fetchDocuments();
    isLoading = false.obs;
  }
}
