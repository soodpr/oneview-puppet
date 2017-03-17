################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require_relative '../image_streamer_resource'

Puppet::Type::Image_streamer_golden_image.provide :image_streamer, parent: Puppet::ImageStreamerResource do
  desc 'Provider for Image Streamer Golden Image using the Image Streamer API'

  mk_resource_methods

  def exists?
    super([nil, :found, :download_details_archive, :download])
    @golden_image_path = @data.delete('golden_image_path')
    !@resourcetype.find_by(@client, @data).empty?
  end

  def create
    current_resource = @resourcetype.find_by(@client, unique_id).first
    return super unless @golden_image_path && !current_resource
    timeout = @data.delete('timeout') || OneviewSDK::Rest::READ_TIMEOUT
    @resourcetype.add(@client, @golden_image_path, @data, timeout)
    true
  end

  def download_details_archive
    archive_path = @data.delete('details_archive_path')
    golden_image = get_single_resource_instance
    golden_image.download_details_archive(archive_path)
    true
  end

  def download
    download_path = @data.delete('golden_image_download_path')
    golden_image = get_single_resource_instance
    golden_image.download(download_path)
    true
  end
end
