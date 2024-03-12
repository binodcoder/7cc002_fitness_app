import 'package:flutter/material.dart';
import '../../../resources/colour_manager.dart';
import '../../../resources/values_manager.dart';

class AddAppointmentDialog extends StatefulWidget {
  final DateTime? selectedDate;
  const AddAppointmentDialog({
    Key? key,
    this.selectedDate,
  }) : super(key: key);
  @override
  AddAppointmentDialogState createState() => AddAppointmentDialogState();
}

class AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  bool focus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: ColorManager.white,
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {}
            },
          ),
        ],
        centerTitle: true,
        title: const Text(
          'New Appointment',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                height: AppHeight.h50,
                margin: EdgeInsets.only(bottom: AppHeight.h10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '') {
                      focus = true;
                      return '*Required';
                    }
                    return null;
                  },
                  //  controller: trainerNameController,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                        borderRadius: BorderRadius.circular(AppRadius.r4),
                      ),
                      labelText: 'Trainer Name*',
                      hintText: 'Enter Trainer Name'),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                width: size.width * 0.46,
                height: AppHeight.h50,
                margin: EdgeInsets.only(bottom: AppHeight.h10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.blue),
                  borderRadius: BorderRadius.circular(AppRadius.r4),
                ),
                child: InkWell(
                  onTap: () {
                    //  addNewAppointmentController.selectDate();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: ColorManager.darkGrey,
                        ),
                        const Text('Date:'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: AppHeight.h50,
                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(AppRadius.r4),
                    ),
                    width: size.width * 0.46,
                    child: InkWell(
                      onTap: () {
                        // addNewAppointmentController.selectFromTime(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: ColorManager.darkGrey,
                            ),
                            const Text('Time From :'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: AppHeight.h50,
                    margin: EdgeInsets.only(bottom: AppHeight.h10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(AppRadius.r4),
                    ),
                    width: size.width * 0.46,
                    child: InkWell(
                      onTap: () {
                        //addNewAppointmentController.selectToTime(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: ColorManager.darkGrey,
                            ),
                            const Text('Time To:'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15.0),
                child: TextFormField(
                  maxLines: 4,
                  minLines: 2,
                  // controller: addNewAppointmentController.remarkController,
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5, color: Colors.blue),
                      borderRadius: BorderRadius.circular(AppRadius.r4),
                    ),
                    labelText: 'Remarks',
                    hintText: 'Enter remarks',
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(width: 300, height: 50),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                            (Set<MaterialState> states) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.r4),
                              );
                            },
                          ),
                        ),
                        onPressed: () async {
                          // if (_formKey.currentState.validate()) {
                          //   if (addNewAppointmentController.loading.value == false) {
                          //     addNewAppointmentController.postData();
                          //   }
                          // }
                        },
                        child: Text('Save'),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
