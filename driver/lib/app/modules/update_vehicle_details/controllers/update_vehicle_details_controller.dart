import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:driver/app/models/driver_user_model.dart';
import 'package:driver/app/models/vehicle_brand_model.dart';
import 'package:driver/app/models/vehicle_model_model.dart';
import 'package:driver/app/models/vehicle_type_model.dart';
import 'package:driver/app/modules/verify_documents/controllers/verify_documents_controller.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant_widgets/show_toast_dialog.dart';
import 'package:driver/utils/fire_store_utils.dart';

class UpdateVehicleDetailsController extends GetxController {
  RxString selectedVehicleTypeId = "".obs;
  Rx<VehicleTypeModel> vehicleTypeModel = VehicleTypeModel(
      id: "",
      image: "",
      isActive: false,
      title: "",
      persons: "0",
      charges: Charges(
        fareMinimumChargesWithinKm: "0",
        farMinimumCharges: "0",
        farePerKm: "0",
      )).obs;
  Rx<VehicleBrandModel> vehicleBrandModel = VehicleBrandModel(id: "", title: "", isEnable: false).obs;
  Rx<VehicleModelModel> vehicleModelModel = VehicleModelModel(id: "", title: "", isEnable: false, brandId: '').obs;
  List<VehicleTypeModel> vehicleTypeList = Constant.vehicleTypeList ?? [];
  RxList<VehicleBrandModel> vehicleBrandList = <VehicleBrandModel>[].obs;
  RxList<VehicleModelModel> vehicleModelList = <VehicleModelModel>[].obs;
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();

  @override
  Future<void> onReady() async {
    // Inicializa a lista de tipos de veículos
    vehicleTypeList = Constant.vehicleTypeList ?? [];
    
    // Inicializa o modelo de tipo de veículo apenas se a lista não estiver vazia
    if (vehicleTypeList.isNotEmpty) {
      selectedVehicleTypeId.value = vehicleTypeList[0].id;
      vehicleTypeModel.value = vehicleTypeList[0];
    }
    
    // Carrega as marcas de veículos
    vehicleBrandList.value = await FireStoreUtils.getVehicleBrand();
    
    // Atualiza os dados do usuário
    updateData();
    super.onReady();
  }

  void updateData() {
    try {
      VerifyDocumentsController uploadDocumentsController = Get.find<VerifyDocumentsController>();
      if (uploadDocumentsController.userModel.value.driverVehicleDetails != null) {
        // Busca o índice do tipo de veículo pelo ID
        String vehicleTypeId = uploadDocumentsController.userModel.value.driverVehicleDetails!.vehicleTypeId ?? '';
        int typeIndex = vehicleTypeList.indexWhere((element) => element.id == vehicleTypeId);
        
        // Se encontrou o tipo de veículo na lista, atualiza o valor selecionado
        if (typeIndex != -1) {
          selectedVehicleTypeId.value = vehicleTypeList[typeIndex].id;
          vehicleTypeModel.value = vehicleTypeList[typeIndex];
        }
        
        // Atualiza os outros campos
        vehicleBrandController.text = uploadDocumentsController.userModel.value.driverVehicleDetails!.brandName ?? '';
        vehicleModelController.text = uploadDocumentsController.userModel.value.driverVehicleDetails!.modelName ?? '';
        vehicleNumberController.text = uploadDocumentsController.userModel.value.driverVehicleDetails!.vehicleNumber ?? '';
      }
    } catch (e) {
      print('Erro ao atualizar dados do veículo: $e');
    }
  }

  VehicleTypeModel? getSelectedVehicleType() {
    if (selectedVehicleTypeId.value.isEmpty) return null;
    try {
      return vehicleTypeList.firstWhere((element) => element.id == selectedVehicleTypeId.value);
    } catch (e) {
      return null;
    }
  }

  Future<void> getVehicleModel(String id) async {
    vehicleModelList.value = await FireStoreUtils.getVehicleModel(id);
  }

  Future<void> saveVehicleDetails() async {
    ShowToastDialog.showLoader("please_wait".tr);
    VerifyDocumentsController verifyDocumentsController = Get.find<VerifyDocumentsController>();
    DriverUserModel? userModel = await FireStoreUtils.getDriverUserProfile(FireStoreUtils.getCurrentUid());
    if (userModel == null) return;
    VehicleTypeModel? selectedType = getSelectedVehicleType();
    DriverVehicleDetails driverVehicleDetails = DriverVehicleDetails(
      brandName: vehicleBrandModel.value.title,
      brandId: vehicleBrandModel.value.id,
      modelName: vehicleModelModel.value.title,
      modelId: vehicleModelModel.value.id,
      vehicleNumber: vehicleNumberController.text,
      isVerified: Constant.isDocumentVerificationEnable == false ? true : false,
      vehicleTypeName: selectedType?.title ?? '',
      vehicleTypeId: selectedType?.id ?? '',
    );
    userModel.driverVehicleDetails = driverVehicleDetails;

    bool isUpdated = await FireStoreUtils.updateDriverUser(userModel);
    ShowToastDialog.closeLoader();
    if (isUpdated) {
      ShowToastDialog.showToast("Vehicle details updated, Please wait for verification.");
      verifyDocumentsController.getData();
      Get.back();
    } else {
      ShowToastDialog.showToast("Something went wrong, Please try again later.");
      Get.back();
    }
  }
}
