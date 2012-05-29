! Copyright (C) 2011
! Free Software Foundation, Inc.

! This file is part of the gtk-fortran GTK+ Fortran Interface library.

! This is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3, or (at your option)
! any later version.

! This software is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

! Under Section 7 of GPL version 3, you are granted additional
! permissions described in the GCC Runtime Library Exception, version
! 3.1, as published by the Free Software Foundation.

! You should have received a copy of the GNU General Public License along with
! this program; see the files COPYING3 and COPYING.RUNTIME respectively.
! If not, see <http://www.gnu.org/licenses/>.
!
! Contributed by James Tappin
! Last modification: 11-30-2011

! --------------------------------------------------------
! gtk-hl-button.f90
! Generated: Tue May 29 17:09:54 2012 GMT
! Please do not edit this file directly,
! Edit gtk-hl-button-tmpl.f90, and use ./mk_gtk_hl.pl to regenerate.
! --------------------------------------------------------


module gtk_hl_button
  !*
  ! Buttons
  ! Convenience interfaces for regular buttons, checkboxes and radio menus.
  !/

  use gtk_sup
  use gtk_hl_misc
  use iso_c_binding
  ! autogenerated use's
  use gtk, only: gtk_button_new, gtk_button_new_with_label,&
       & gtk_check_button_new, gtk_check_button_new_with_label,&
       & gtk_radio_button_get_group, gtk_radio_button_new,&
       & gtk_radio_button_new_with_label, gtk_toggle_button_get_active,&
       & gtk_toggle_button_set_active, gtk_widget_add_accelerator,&
       & gtk_widget_set_sensitive, gtk_widget_set_tooltip_text, &
       & gtk_label_new, gtk_label_set_markup, gtk_container_add,&
       & gtk_button_set_label, &
       & TRUE, FALSE, g_signal_connect

  use g, only: g_slist_length, g_slist_nth, g_slist_nth_data

  use gtk_hl_accelerator

  implicit none

contains
  !+
  function hl_gtk_button_new(label, clicked, data, tooltip, sensitive, &
       & accel_key, accel_mods, accel_group, accel_flags, is_markup) result(but)

    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: clicked
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: sensitive
    character(kind=c_char), dimension(*), optional, intent(in) :: accel_key
    integer(kind=c_int), optional, intent(in) :: accel_mods, accel_flags
    type(c_ptr), optional, intent(in) :: accel_group
    integer(kind=c_int), optional, intent(in) :: is_markup

    ! Higher-level button
    !
    ! LABEL: string: required: The label on the button
    ! CLICKED: c_funptr: optional: callback routine for the "clicked" signal
    ! DATA: c_ptr: optional: Data to be passed to the clicked callback
    ! TOOLTIP: string: optional: tooltip to be displayed when the pointer
    ! 		is held over the button.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    ! ACCEL_KEY: string: optional: Set to the character value or code of a
    ! 		key to use as an accelerator.
    ! ACCEL_MODS: c_int: optional: Set to the modifiers for the accelerator.
    ! 		(If not given then GTK_CONTROL_MASK is assumed).
    ! ACCEL_GROUP: c_ptr: optional: The accelerator group to which the
    ! 		accelerator is attached, must have been added to the top-level
    ! 		window.
    ! ACCEL_FLAGS: c_int: optional: Flags for the accelerator, if not present
    ! 		then GTK_ACCEL_VISIBLE, is used (to hide the accelerator,
    ! 		use ACCEL_FLAGS=0).
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    type(c_ptr) :: label_w
    logical :: markup

    if (present(is_markup)) then
       markup = c_f_logical(is_markup)
    else
       markup = .false.
    end if

    if(markup) then
       but = gtk_button_new()
       label_w=gtk_label_new(c_null_char)
       call gtk_label_set_markup(label_w, label)
       call gtk_container_add(but, label_w)
    else
       but=gtk_button_new_with_label(label)
    end if

    if (present(clicked)) then
       if (present(data)) then
          call g_signal_connect(but, "clicked"//C_NULL_CHAR, &
               & clicked, data)
       else
          call g_signal_connect(but, "clicked"//C_NULL_CHAR, &
               & clicked)
       end if

       ! An accelerator
       if (present(accel_key) .and. present(accel_group)) &
            & call hl_gtk_widget_add_accelerator(but, "clicked"//c_null_char, &
            & accel_group, accel_key, accel_mods, accel_flags)

    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)
    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_button_new

  !+
  subroutine hl_gtk_button_set_label(button, label, is_markup)
    type(c_ptr), intent(in) :: button
    character(kind=c_char), dimension(*), intent(in) :: label
    integer(kind=c_int), intent(in), optional :: is_markup

    ! Set the label of a button, including using markup.
    !
    ! BUTTON: c_ptr: required: The button to modify.
    ! LABEL: string: required: The new label for the button.
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		pango markup.
    !-

    logical :: markup
    type(c_ptr) :: label_w

    if (present(is_markup)) then
       markup = c_f_logical(is_markup)
    else
       markup = .false.
    end if

    if (markup) then
       label_w = gtk_bin_get_child(button)
       call gtk_label_set_markup(label_w, label)
    else
       call gtk_button_set_label(button, label)
    end if
  end subroutine hl_gtk_button_set_label

  !+
  function hl_gtk_check_button_new(label, toggled, data, tooltip, &
       & initial_state, sensitive, is_markup) result(but)

    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: initial_state
    integer(kind=c_int), intent(in), optional :: sensitive, is_markup

    ! Higher level check box.
    !
    ! LABEL: string: required:  The label on the button.
    ! TOGGLED: c_funptr: optional: Callback function for the "toggled" signal.
    ! DATA: c_ptr: optional: Data to pass to/from the toggled callback.
    ! TOOLTIP: string: optional: A tooltip for the check_button.
    ! INITIAL_STATE: integer: optional: set the initial state of the
    !               check_button.
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    type(c_ptr) :: label_w
    logical :: markup

    if (present(is_markup)) then
       markup = c_f_logical(is_markup)
    else
       markup = .false.
    end if

    if(markup) then
       but = gtk_check_button_new()
       label_w=gtk_label_new(c_null_char)
       call gtk_label_set_markup(label_w, label)
       call gtk_container_add(but, label_w)
    else
       but = gtk_check_button_new_with_label(label)
    end if

    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(but, "toggled"//c_null_char, toggled, data)
       else
          call g_signal_connect(but, "toggled"//c_null_char, toggled)
       end if
    end if

    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)

    if (present(initial_state)) &
         & call gtk_toggle_button_set_active(but, initial_state)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_check_button_new

  !+
  function hl_gtk_radio_button_new(group, label, toggled, data, tooltip, &
       & sensitive, is_markup) result(but)

    type(c_ptr) :: but
    type(c_ptr), intent(inout) :: group
    character(kind=c_char), dimension(*), intent(in) :: label
    type(c_funptr), optional :: toggled
    type(c_ptr), optional :: data
    character(kind=c_char), dimension(*), intent(in), optional :: tooltip
    integer(kind=c_int), intent(in), optional :: sensitive, is_markup

    ! Radio button
    !
    ! GROUP: c_ptr: required: The group to which the button belongs.
    ! 		This is an INOUT argument so it must be a variable
    ! 		of type(c_ptr). To start a new group (menu) initialize
    ! 		the variable to C_NULL_PTR, to add a new button use the value
    ! 		returned from the last call to hl_gtk_radio_button_new. This
    ! 		is the variable which you use to do things like setting the
    ! 		selection.
    ! LABEL: string: required: The label for the button.
    ! TOGGLED: c_funptr: optional: call back to be executed when the
    ! 		button is toggled
    ! DATA: c_ptr: optional: Data to pass to/from the "toggled" callback.
    ! TOOLTIP: string: optional: A tooltip for the radio button
    ! SENSITIVE: boolean: optional: Whether the widget should initially
    ! 		be sensitive or not.
    ! IS_MARKUP: boolean: optional: Set this to TRUE if the label contains
    ! 		Pango markup.
    !-

    type(c_ptr) :: label_w
    logical :: markup

    if (present(is_markup)) then
       markup = c_f_logical(is_markup)
    else
       markup = .false.
    end if

    if(markup) then
       but = gtk_radio_button_new(group)
       label_w=gtk_label_new(c_null_char)
       call gtk_label_set_markup(label_w, label)
       call gtk_container_add(but, label_w)
    else
       but = gtk_radio_button_new_with_label(group, label)
    end if

    group = gtk_radio_button_get_group(but)

    if (present(toggled)) then
       if (present(data)) then
          call g_signal_connect(but, "toggled"//c_null_char, toggled, data)
       else
          call g_signal_connect(but, "toggled"//c_null_char, toggled)
       end if
    end if
    if (present(tooltip)) call gtk_widget_set_tooltip_text(but, tooltip)

    if (present(sensitive)) &
         & call gtk_widget_set_sensitive(but, sensitive)

  end function hl_gtk_radio_button_new

  !+
  subroutine hl_gtk_radio_group_set_select(group, index)

    type(c_ptr), intent(in) :: group
    integer(kind=c_int), intent(in) :: index

    ! Set the indexth button of a radio group
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    ! INDEX: integer: required: The index of the button to set
    ! 		(starting from the first as 0).
    !-

    integer(kind=c_int) :: nbuts
    type(c_ptr) :: datan

    nbuts = g_slist_length(group)

    ! Note that GROUP actually points to the last button added and to the
    ! group of the next to last & so on

    datan= g_slist_nth_data(group, nbuts-index-1)
    call gtk_toggle_button_set_active(datan, TRUE)

  end subroutine hl_gtk_radio_group_set_select

  !+
  function hl_gtk_radio_group_get_select(group) result(index)

    integer(kind=c_int) :: index
    type(c_ptr) :: group

    ! Find the selected button in a radio group.
    !
    ! GROUP: c_ptr: required: The group of the last button added to
    ! 		the radio menu
    !-

    integer(kind=c_int) :: nbuts, i
    type(c_ptr) :: but

    nbuts = g_slist_length(group)
    index=-1

    do i = 1, nbuts
       but = g_slist_nth_data(group, nbuts-i)
       if (.not. c_associated(but)) exit

       if (gtk_toggle_button_get_active(but)==TRUE) then
          index = i-1
          return
       end if
    end do
  end function hl_gtk_radio_group_get_select

  !+
  subroutine hl_gtk_button_set_label_markup(but, label)
    type(c_ptr) :: but
    character(kind=c_char), dimension(*), intent(in) :: label

    ! Set a markup label on a button
    !
    ! BUT: c_ptr: required: The button to relabel
    ! LABEL: string: required: The string (with Pango markup) to apply.
    !
    ! Normally if the label does not need Pango markup, then
    ! gtk_button_set_label can be used.
    !-

    call hl_gtk_bin_set_label_markup(but, label)

  end subroutine hl_gtk_button_set_label_markup
end module gtk_hl_button
