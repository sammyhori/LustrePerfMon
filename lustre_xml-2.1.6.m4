include(`lustre_xml.m4')dnl
HEAD(Lustre-2.1.6)
<definition>
	<version>2.1.6</version>
	<entry>
		<subpath>
			<subpath_type>constant</subpath_type>
			<path>/proc/fs/lustre</path>
		</subpath>
		<mode>directory</mode>
		CONSTANT_FILE_ENTRY(2, health_check, lustre_health, (.+), string, NA, NA, NA, NA, NA, 1)
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>version</path>
			</subpath>
			<mode>file</mode>
			ONE_FIELD_ITEM(3, lustre_version, lustre_version,
			lustre: ([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+), string, NA, NA, NA, NA, NA, 1)
			ONE_FIELD_ITEM(3, kernel_type, kernel_type, kernel: (patchless_client), string, NA, NA, NA, NA, NA, 1)
			ONE_FIELD_ITEM(3, build_version, build_version, build:  (.+), string, NA, NA, NA, NA, NA, 1)
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>mdt</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>regular_expression</subpath_type>
					<path>(^.+-MDT[0-9a-fA-F]+$)</path>
					<subpath_field>
						<index>1</index>
						<name>mdt_name</name>
					</subpath_field>
				</subpath>
				<mode>directory</mode>
				<entry>
					<!-- mds_stats_counter_init() -->
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>md_stats</path>
					</subpath>
					<mode>file</mode>
					MD_STATS_ITEM(5, open, 1)
					MD_STATS_ITEM(5, close, 1)
					MD_STATS_ITEM(5, mknod, 1)
					MD_STATS_ITEM(5, link, 1)
					MD_STATS_ITEM(5, unlink, 1)
					MD_STATS_ITEM(5, mkdir, 1)
					MD_STATS_ITEM(5, rmdir, 1)
					MD_STATS_ITEM(5, rename, 1)
					MD_STATS_ITEM(5, getattr, 1)
					MD_STATS_ITEM(5, setattr, 1)
					MD_STATS_ITEM(5, getxattr, 1)
					MD_STATS_ITEM(5, setxattr, 1)
					MD_STATS_ITEM(5, statfs, 1)
					MD_STATS_ITEM(5, sync, 1)
				</entry>
			</entry>
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>obdfilter</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>regular_expression</subpath_type>
					<path>(^.+-OST[0-9a-fA-F]+$)</path>
					<subpath_field>
						<index>1</index>
						<name>ost_name</name>
					</subpath_field>
				</subpath>
				<mode>directory</mode>
				<entry>
					<!-- filter_setup().
					     There are a lot of counter, only defined part of them here
					-->
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>stats</path>
					</subpath>
					<mode>file</mode>
					<item>
						<name>ost_stats_read</name>
						<pattern>read_bytes +([[:digit:]]+) samples \[bytes\] [[:digit:]]+ [[:digit:]]+ ([[:digit:]]+)</pattern>
						FIELD(6, 1, read_samples, number, ${key:hostname}, ${subpath:ost_name}, stats, derive, read_samples, 1)
						FIELD(6, 2, read_bytes, number, ${key:hostname}, ${subpath:ost_name}, stats, derive, read_bytes, 1)
					</item>
					<item>
						<name>ost_stats_write</name>
						<pattern>write_bytes +([[:digit:]]+) samples \[bytes\] [[:digit:]]+ [[:digit:]]+ ([[:digit:]]+)</pattern>
						FIELD(6, 1, write_samples, number, ${key:hostname}, ${subpath:ost_name}, stats, derive, write_samples, 1)
						FIELD(6, 2, write_bytes, number, ${key:hostname}, ${subpath:ost_name}, stats, derive, write_bytes, 1)
					</item>
					OST_STATS_ITEM(5, get_page, usec, 1)
					<item>
						<name>ost_stats_get_page_failures</name>
						<pattern>get_page failures +([[:digit:]]+) samples \[num\]</pattern>
						FIELD(6, 1, get_page_failures, number, ${key:hostname}, ${subpath:ost_name}, stats, derive, get_page_failures, 1)
					</item>
					OST_STATS_ITEM(5, cache_access, pages, 1)
					OST_STATS_ITEM(5, cache_hit, pages, 1)
					OST_STATS_ITEM(5, cache_miss, pages, 1)
					<!-- Following comes from filter_setup()/lprocfs_alloc_obd_stats()/lprocfs_init_ops_stats()
					     Not necessarily available.
					-->
					OST_STATS_ITEM(5, getattr, reqs, 1)
					OST_STATS_ITEM(5, setattr, reqs, 1)
					OST_STATS_ITEM(5, punch, reqs, 1)
					OST_STATS_ITEM(5, sync, reqs, 1)
					OST_STATS_ITEM(5, destroy, reqs, 1)
					OST_STATS_ITEM(5, create, reqs, 1)
					OST_STATS_ITEM(5, statfs, reqs, 1)
					OST_STATS_ITEM(5, get_info, reqs, 1)
					OST_STATS_ITEM(5, set_info_async, reqs, 1)
					OST_STATS_ITEM(5, quotactl, reqs, 1)
				</entry>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>brw_stats</path>
					</subpath>
					<mode>file</mode>
					OST_BRW_STATS_ITEM(5, rpc_bulk, ^pages per bulk .+
(.+
)*$, [[:digit:]]+[KM]?, pages, 1)
					OST_BRW_STATS_ITEM(5, page_discontiguous_rpc, ^discontiguous pages .+
(.+
)*$, [[:digit:]]+[KM]?, pages, 1)
					OST_BRW_STATS_ITEM(5, block_discontiguous_rpc, ^discontiguous blocks .+
(.+
)*$, [[:digit:]]+[KM]?, blocks, 1)
					OST_BRW_STATS_ITEM(5, fragmented_io, ^disk fragmented .+
(.+
)*$, [[:digit:]]+[KM]?, fragments, 1)
					OST_BRW_STATS_ITEM(5, io_in_flight, ^disk I/Os .+
(.+
)*$, [[:digit:]]+[KM]?, ios, 1)
					OST_BRW_STATS_ITEM(5, io_time, ^I/O time .+
(.+
)*$, [[:digit:]]+[KM]?, milliseconds, 1)
					OST_BRW_STATS_ITEM(5, io_size, ^disk I/O size .+
(.+
)*$, [[:digit:]]+[KM]?, Bytes, 1)
				</entry>
				FILES_KBYTES_INFO_ENTRIES(4, ost, ${subpath:ost_name}, 1)
			</entry>
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>mdc</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>regular_expression</subpath_type>
					<path>(^.+-MDT.+-mdc).+$</path>
					<subpath_field>
						<index>1</index>
						<name>mdc_mdt_name</name>
					</subpath_field>
				</subpath>
				<mode>directory</mode>
				CONSTANT_FILE_ENTRY(4, max_rpcs_in_flight, max_rpcs_in_flight,
						    (.+), number, ${key:hostname}, ${subpath:mdc_mdt_name},
						    mdc_rpcs, gauge, max_rpcs_in_flight, 1)
			</entry>
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>mds</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>constant</subpath_type>
					<path>MDS</path>
				</subpath>
				<mode>directory</mode>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>mdt</path>
					</subpath>
					<mode>directory</mode>
					THREAD_INFO_ENTRIES(5, mds, mds, normal_metadata_ops, gauge, 1)
				</entry>
			</entry>
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>ost</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>constant</subpath_type>
					<path>OSS</path>
				</subpath>
				<mode>directory</mode>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>ost</path>
					</subpath>
					<mode>directory</mode>
					THREAD_INFO_ENTRIES(5, ost, ost, normal_data, gauge, 1)
				</entry>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>ost_io</path>
					</subpath>
					<mode>directory</mode>
					<entry>
						<subpath>
							<subpath_type>constant</subpath_type>
							<path>stats</path>
						</subpath>
						<mode>file</mode>
						OST_IO_STATS_ITEM(6, req_waittime, usec, 1)
						OST_IO_STATS_ITEM(6, req_qdepth, reqs, 1)
						OST_IO_STATS_ITEM(6, req_active, reqs, 1)
						OST_IO_STATS_ITEM(6, req_timeout, sec, 1)
						OST_IO_STATS_ITEM(6, reqbuf_avail, bufs, 1)
						OST_IO_STATS_ITEM(6, ost_read, usec, 1)
						OST_IO_STATS_ITEM(6, ost_write, usec, 1)
						OST_IO_STATS_ITEM(6, ost_punch, usec, 1)
					</entry>
					THREAD_INFO_ENTRIES(5, ost_io, ost, bulk_data_IO, gauge, 1)
				</entry>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>ost_create</path>
					</subpath>
					<mode>directory</mode>
					THREAD_INFO_ENTRIES(5, ost_create, ost, obj_pre-creation_service, gauge, 1)
				</entry>
			</entry>
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>ldlm</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>constant</subpath_type>
					<path>services</path>
				</subpath>
				<mode>directory</mode>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>ldlm_canceld</path>
					</subpath>
					<mode>directory</mode>
					THREAD_INFO_ENTRIES(5, ldlm_cancel, ldlm_service, lock_cancel, gauge, 1)
				</entry>
				<entry>
					<subpath>
						<subpath_type>constant</subpath_type>
						<path>ldlm_cbd</path>
					</subpath>
					<mode>directory</mode>
					THREAD_INFO_ENTRIES(5, ldlm_cbd, ldlm_service, lock_grant, gauge, 1)
				</entry>
			</entry>
		</entry>
		<entry>
			<subpath>
				<subpath_type>constant</subpath_type>
				<path>lov</path>
			</subpath>
			<mode>directory</mode>
			<entry>
				<subpath>
					<subpath_type>regular_expression</subpath_type>
					<path>(^.+-MDT[0-9a-fA-F]+)-mdtlov</path>
					<subpath_field>
						<index>1</index>
						<name>lod_mdt_name</name>
					</subpath_field>
				</subpath>
				<mode>directory</mode>
				FILES_KBYTES_INFO_ENTRIES(4, mdt, ${subpath:lod_mdt_name}, 1)
			</entry>
		</entry>
	</entry>
</definition>

