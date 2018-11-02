def state()
  $daw_state ||= {}
end

def linear_map(x0, x1, y0, y1, x)
  dydx = (y1 - y0) / (x1- x0)
  dx = (x- x0)
  (y0 + (dydx * dx))
end


def warm
  alive pad: 1 , apeg: 1, bass: 1, piano: 1, vocal: 1, kick: 1
  [:c3, :cs3, :d3, :ds3, :e3, :f3, :fs3, :g3, :gs3, :a3, :as3, :b3,
    :c4, :cs4, :d4, :ds4, :e4, :f4, :fs4, :g4, :gs4, :a4, :as4, :b4,
    :c5, :cs5, :d5, :ds5, :e5, :f5, :fs5, :g5, :gs5, :a5, :as5, :b5,
  ].each{|n|
    midi n,1, sus: 0.125, port: '*', channel: '*'
    sleep 0.25
    }
end

def zero_delay(phases)
  delays = phases
  zero_cc rdelay: delays[0], ldelay: delays[1], cdelay: delays[2]
end

def zero_cc(cc)
  channel = 5
  cc.keys.each do |k|
    n = case k
        when :wash; 60
        when :delay_note; 64
          m={
        note('c-1') => 0, note('cs-1') => 1, note('d-1') => 3, note('ds-1') => 5, note('e-1') => 7, note('f-1') => 8, note('fs-1') => 10, note('g-1') => 12, note('gs-1') => 14,  note('a-1') => 15, note('as-1') => 17, note('b-1') => 19,

        note('c0') => 21, note('cs0') => 23, note('d0') => 25, note('ds0') => 27, note('e0') => 29, note('f0') => 30, note('fs0') => 32, note('g0') => 34, note('gs0') => 36,  note('a0') => 37, note('as0') => 39, note('b0') => 41,

        note('c1') => 43, note('cs1') => 44, note('d1') => 46, note('ds1') => 48, note('e1') => 50, note('f1') => 52, note('fs1') => 53, note('g1') => 55, note('gs1') => 57,  note('a1') => 58, note('as1') => 60, note('b1') => 62,

        note('c2') => 64, note('cs2') => 65, note('d2') => 67, note('ds2') => 69, note('e2') => 71, note('f2') => 73, note('fs2') => 74, note('g2') => 76, note('gs2') => 77,  note('a2') => 79, note('as2') => 81, note('b2') => 83,

        note('c3') => 85, note('cs3') => 86, note('d3') => 88, note('ds3') => 90, note('e3') => 92, note('f3') => 94, note('fs3') => 95, note('g3') => 97, note('gs3') => 99,  note('a3') => 100, note('as3') => 102, note('b3') => 104,

        note('c4') => 106, note('cs4') => 107, note('d4') => 109, note('ds4') => 111, note('e4') => 113, note('f4') => 115, note('fs4') => 116, note('g4') => 118, note('gs4') => 120,  note('a4') => 122, note('as4') => 124, note('b4') => 126,

        note('c5') => 127}
          v = m[note(cc[k])]
          if v
            midi_cc 64, v, port: :iac_bus_1, channel: channel
          end
          nil
        when :cdelay
          m={1=> 0, 2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
          v = m[cc[k]]
          if v
            midi_cc 61, 127*v, port: :iac_bus_1, channel: channel
          end
          nil
        when :ldelay
          m={1=> 0, 2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
          v = m[cc[k]]
          if v
            midi_cc 62, 127*v, port: :iac_bus_1, channel: channel
          end

          nil
        when :rdelay
          m={1=> 0, 2 => 0.2, 3=>0.25, 4=> 0.4, 5=> 0.5, 6 => 0.65, 8 => 0.8, 16=> 1.0}
          v = m[cc[k]]
          if v
            midi_cc 63, 127*v, port: :iac_bus_1, channel: channel
          end
          nil
        else
          nil
        end
    if n == 49
      #midi_pitch_bend cc[k], channel: 4
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: channel
    end
  end
end

def arp(*args)
  channel = 7
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: channel})
  end
end
def arp_on(*args)
  channel = 7
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {channel: channel})
  end
end
def arp_x(*args)
  channel = 7
  midi_all_notes_off *(args << {channel: channel})
end


def creature(*args)
  channel = 10
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi n,vel, *(args << {channel: channel})
    creature_cc opts
  end
end
def creature_on(*args)
  channel = 10
  params, opts = split_params_and_merge_opts_array(args)
  opts         = current_midi_defaults.merge(opts)
  n, vel = *params
  if n
    midi_note_on n,vel, *(args << {channel: channel})
    creature_cc opts
  end
end
def creature_x(*args)
  channel = 10
  midi_all_notes_off *(args << {channel: channel})
end

def creature_cc(cc)
    channel = 10
  cc.keys.each do |k|
    n = case k
        when :dirt; 51
        when :filter; 52
        when :talk; 53
        when :ryth; 54
        else
          nil
        end
    if n == 49
      midi_pitch_bend cc[k], channel: channel
    elsif n
      midi_cc n, cc[k]*127.0, port: :iac_bus_1, channel: channel
    end
  end

end
