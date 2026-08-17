import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class PesticideEvent extends Equatable {
  const PesticideEvent();

  @override
  List<Object?> get props => [];
}

// ဓာတ်ပုံ ပို့ပေးပြီး Scan ဖတ်ရန် Event
class ScanPesticideEvent extends PesticideEvent {
  final File imageFile;

  const ScanPesticideEvent(this.imageFile);

  @override
  List<Object?> get props => [imageFile];
}

// State ပြန်လည် Reset လျှောက်ရန် Event
class ResetPesticideEvent extends PesticideEvent {}
