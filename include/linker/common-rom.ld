#ifdef CONFIG_CPLUSPLUS
	SECTION_PROLOGUE(_CTOR_SECTION_NAME,,)
	{
		/*
		 * The compiler fills the constructor pointers table below,
		 * hence symbol __CTOR_LIST__ must be aligned on 4 byte
		 * boundary.  To align with the C++ standard, the first elment
		 * of the array contains the number of actual constructors. The
		 * last element is NULL.
		 */
		. = ALIGN(4);
		__CTOR_LIST__ = .;
		LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
		KEEP(*(SORT_BY_NAME(".ctors*")))
		LONG(0)
		__CTOR_END__ = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

	SECTION_PROLOGUE(init_array, (OPTIONAL),)
	{
		. = ALIGN(4);
		__init_array_start = .;
		KEEP(*(SORT_BY_NAME(".init_array*")))
		__init_array_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)
#endif
#ifdef CONFIG_USERSPACE
	/* Build-time assignment of permissions to kernel objects to
	 * threads declared with K_THREAD_DEFINE()
	 */
	SECTION_PROLOGUE(object_access, (OPTIONAL),)
	{
		__object_access_start = .;
		KEEP(*(".object_access.*"))
		__object_access_end = .;
	}
#endif
	SECTION_PROLOGUE (devconfig, (OPTIONAL),)
	{
		__devconfig_start = .;
		*(".devconfig.*")
		KEEP(*(SORT_BY_NAME(".devconfig*")))
		__devconfig_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

	SECTION_PROLOGUE(net_l2, (OPTIONAL),)
	{
		__net_l2_start = .;
		*(".net_l2.init")
		KEEP(*(SORT_BY_NAME(".net_l2.init*")))
		__net_l2_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

#if defined(CONFIG_BT_SETTINGS)
	SECTION_DATA_PROLOGUE(_bt_settings_area, (OPTIONAL), SUBALIGN(4))
	{
		_bt_settings_start = .;
		KEEP(*(SORT_BY_NAME("._bt_settings.static.*")))
		_bt_settings_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)
#endif

	SECTION_DATA_PROLOGUE(log_const_sections, (OPTIONAL),)
	{
		__log_const_start = .;
		KEEP(*(SORT(.log_const_*)));
		__log_const_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

	SECTION_DATA_PROLOGUE(log_backends_sections, (OPTIONAL),)
	{
		__log_backends_start = .;
		KEEP(*(".log_backends"));
		__log_backends_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

	SECTION_DATA_PROLOGUE(shell_root_cmds_sections, (OPTIONAL),)
	{
		__shell_root_cmds_start = .;
		KEEP(*(SORT(.shell_root_cmd_*)));
		__shell_root_cmds_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)

	SECTION_DATA_PROLOGUE(font_entry_sections, (OPTIONAL),)
	{
		__font_entry_start = .;
		KEEP(*(SORT_BY_NAME(".font_entry.*")))
		__font_entry_end = .;
	} GROUP_LINK_IN(ROMABLE_REGION)
