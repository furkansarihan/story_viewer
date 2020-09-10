import 'package:flutter/material.dart';

class Customizer {
  final String cameraSource;
  final String gallerySource;
  final String replyPlaceholder;
  final String slideToSee;
  final String seconds;
  final String minutes;
  final String hours;
  final String days;
  final IconData closeIcon;
  final IconData infoIcon;
  final IconData failedImageIcon;
  final IconData sendIcon;
  final IconData gallerySourceIcon;
  final IconData cameraSourceIcon;

  Customizer({
    this.cameraSource = "Camera",
    this.gallerySource = "Gallery",
    this.replyPlaceholder = "Message...",
    this.slideToSee = "Slide to see...",
    this.seconds = "s",
    this.minutes = "m",
    this.hours = "h",
    this.days = "d",
    this.closeIcon = Icons.close,
    this.infoIcon = Icons.more_horiz,
    this.failedImageIcon = Icons.broken_image,
    this.sendIcon = Icons.send,
    this.gallerySourceIcon = Icons.image,
    this.cameraSourceIcon = Icons.camera_alt,
  });
}
