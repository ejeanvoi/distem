require 'wrekavoc'
require 'ext/cpuhogs'

module Wrekavoc
  module Limitation
    module CPU

      class HogsAlgorithm
        def initialize()
          @ext = nil
        end

        def apply(vcpu)
          coresdesc = {}

          if vcpu and vcpu.vcores
            vcpu.vcores.each_value do |vcore|
              coresdesc[vcore.pcore.physicalid.to_i] = \
                vcore.frequency / vcore.pcore.frequency \
                if vcore.frequency < vcore.pcore.frequency
            end
          end

          unless coresdesc.empty?
            @ext = CPUExtension::CPUHogs.new
            @ext.run(coresdesc)
          end
        end

        def undo()
          @ext.stop if @ext
        end
      end

    end
  end
end
