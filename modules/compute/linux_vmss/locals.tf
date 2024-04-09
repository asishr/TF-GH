locals {
  # Azure demands Period of Time 1 day 12 hours and 30 minutes to be written as "P1DT12H30M".
  # Note the "T", which we insert only if there are non-zero hours/minutes.
  # What's worse, time periods "PT61M" and "PT1H1M" are equal for Azure, so Azure corrects them, but they are
  # considered inequal inside the `terraform plan`.
  # Using solely the number of minutes ("PT61M") causes a bad Terraform apply loop. The same happens for any string
  # that Azure decides to correct for us.
  scaleout_cooldown_minutes = "${var.scaleout_cooldown_minutes % 60}M"
  scaleout_cooldown_hours   = "${floor(var.scaleout_cooldown_minutes / 60) % 24}H"
  scaleout_cooldown_days    = "${floor(var.scaleout_cooldown_minutes / (60 * 24))}D"
  scaleout_cooldown_t       = "T${local.scaleout_cooldown_hours != "0H" ? local.scaleout_cooldown_hours : ""}${local.scaleout_cooldown_minutes != "0M" ? local.scaleout_cooldown_minutes : ""}"
  scaleout_cooldown         = "P${local.scaleout_cooldown_days != "0D" ? local.scaleout_cooldown_days : ""}${local.scaleout_cooldown_t != "T" ? local.scaleout_cooldown_t : ""}"

  scaleout_window_minutes = "${var.scaleout_window_minutes % 60}M"
  scaleout_window_hours   = "${floor(var.scaleout_window_minutes / 60) % 24}H"
  scaleout_window_days    = "${floor(var.scaleout_window_minutes / (60 * 24))}D"
  scaleout_window_t       = "T${local.scaleout_window_hours != "0H" ? local.scaleout_window_hours : ""}${local.scaleout_window_minutes != "0M" ? local.scaleout_window_minutes : ""}"
  scaleout_window         = "P${local.scaleout_window_days != "0D" ? local.scaleout_window_days : ""}${local.scaleout_window_t != "T" ? local.scaleout_window_t : ""}"

  scalein_cooldown_minutes = "${var.scalein_cooldown_minutes % 60}M"
  scalein_cooldown_hours   = "${floor(var.scalein_cooldown_minutes / 60) % 24}H"
  scalein_cooldown_days    = "${floor(var.scalein_cooldown_minutes / (60 * 24))}D"
  scalein_cooldown_t       = "T${local.scalein_cooldown_hours != "0H" ? local.scalein_cooldown_hours : ""}${local.scalein_cooldown_minutes != "0M" ? local.scalein_cooldown_minutes : ""}"
  scalein_cooldown         = "P${local.scalein_cooldown_days != "0D" ? local.scalein_cooldown_days : ""}${local.scalein_cooldown_t != "T" ? local.scalein_cooldown_t : ""}"

  scalein_window_minutes = "${var.scalein_window_minutes % 60}M"
  scalein_window_hours   = "${floor(var.scalein_window_minutes / 60) % 24}H"
  scalein_window_days    = "${floor(var.scalein_window_minutes / (60 * 24))}D"
  scalein_window_t       = "T${local.scalein_window_hours != "0H" ? local.scalein_window_hours : ""}${local.scalein_window_minutes != "0M" ? local.scalein_window_minutes : ""}"
  scalein_window         = "P${local.scalein_window_days != "0D" ? local.scalein_window_days : ""}${local.scalein_window_t != "T" ? local.scalein_window_t : ""}"

}