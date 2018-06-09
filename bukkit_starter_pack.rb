#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'
require_relative 'lib/helper'
require_relative 'lib/config'
require_relative 'lib/starter_pack'
require_relative 'lib/download_manager'

pack = StarterPack.new
