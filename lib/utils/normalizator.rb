# encoding: UTF-8

module Normalizator
  SYNONYM = [{word: 'Điện thoại di động', synonym: ['mobile', 'điện thoại di động', 'di động', 'iphone', 'smartphone', 'điện thoại']},
    {word: 'Máy tính bảng', synonym: ['tablet', 'ipad', 'máy tính bảng', 'tablet pc', 'máy tính bảng tablet pc']},
    {word: 'Máy đọc sách', synonym: ['ereader', 'e-reader', 'ebooks reader', 'máy đọc sách']},
    {word: 'Laptop & netbook', synonym: ['laptop', 'máy tính xách tay', 'ultrabook', 'netbook', 'máy tính laptop', 'laptop chính hãng']},
    {word: 'Phụ kiện laptop & máy tính', synonym: ['phụ kiện laptop', 'đồ chơi laptop', 'laptop accessories', 'mac accessories']},
    {word: 'Linh kiện máy tính', synonym: ['linh kiện máy tính']},
    {word: 'Phụ kiện máy tính bảng', synonym: ['phụ kiện tablets', 'phụ kiện ipad', 'phụ kiện tablet', 'ipad accessories', 'phụ kiện ipad ipad accessories']},
    {word: 'Phụ kiện điện thoại', synonym: ['sạc điện thoại', 'phụ kiện iphone', 'phụ kiện smartphone', 'iphone accessories', 'các phụ kiện điện thoại khác', 'bao đựng ốp lưng điện thoại']},
    {word: 'Thiết bị mạng', synonym: ['usb modem usb 3g', 'modem', 'router', 'phụ kiện mạng', 'wifi card', 'dây mạng', 'cáp mạng', 'access point wifi', 'lan card', 'modems', 'hub switch', 'thiết bị kết nối 3g 3g datacard', 'pin battery', 'sạc xe hơi']},
    {word: 'HDD, SSD', synonym: ['ổ cứng ssd', 'hdd', 'ssd', 'hdd 3.5 inch ổ cứng desktop', 'hdd 2.5 inch ổ cứng laptop']},
    {word: ['Linh kiện máy tính', 'Khác'], synonym: ['các thiết bị tản nhiệt', 'dây nối cable', 'hdd box', 'webcam', 'đầu đọc thẻ nhớ', 'sound card', 'portable speaker loa ngoài cho laptop máy nghe nhạc', 'sạc pin laptop adapter', 'pin laptop']},
    {word: ['Linh kiện máy tính', 'Nguồn'], synonym: ['nguồn điện psu', 'bộ lưu điện ups']},
    {word: ['Linh kiện máy tính', 'Chuột & bàn phím'], synonym: ['bộ bàn phím chuột', 'mouse keyboard', 'mouse', 'bàn phím']},
    {word: ['Linh kiện máy tính', 'Loa máy tính'], synonym: ['loa máy tính', 'speaker']},
    {word: 'CPU', synonym: ['cpu server', 'cpu', 'cpu desktop']},
    {word: 'USB, Thẻ nhớ, Ổ cứng di động', synonym: ['usb memory', 'sd card', 'usb', 'hdd di động ổ cứng cắm ngoài', 'ổ cứng di động', 'thẻ nhớ']},
    {word: 'Ổ đĩa quang', synonym: ['dvd drive', 'odd']},
    {word: 'RAM', synonym: ['ram desktop', 'ram laptop', 'ram']},
    {word: 'VGA', synonym: ['card màn hình', 'video card', 'vga', 'card đồ họa', 'vga card']},
    {word: 'Mainboard', synonym: ['mainboard', 'bo mạch chủ', 'motherboard']},
    {word: 'Máy in', synonym: ['máy in', 'máy in phun', 'máy in laser đen trắng', 'máy in all in one']},
    {word: 'Máy scan', synonym: ['máy scan', 'bo mạch chủ', 'motherboard']},
    {word: 'Loa', synonym: ['loa', 'speaker']},
    {word: 'Headphone', synonym: ['headphone', 'tai nghe', 'head phone']},
    {word: 'Máy ảnh', synonym: ['máy ảnh', 'camera']},
    {word: 'Máy nghe nhạc', synonym: ['máy nghe nhạc', 'máy nghe nhạc mp3', 'máy nghe nhạc mp4', 'portable media player pmp']},
    {word: 'Màn hình LCD', synonym: ['màn hình lcd']},
    {word: 'Máy chiếu', synonym: ['projector máy chiếu']},
    {word: 'Desktop & All-In-Ones', synonym: ['máy tính desktop', 'macs desktop']},
    {word: 'PDA', synonym: ['pda']}]

  def Normalizator.normalize(value)
    result = nil
    if value.class == String
      dict = SYNONYM.detect {|d| d[:synonym].include? value}
      if dict
        result = dict[:word]
      end
    elsif value.class == Array
      while !value.blank?
        new_value = value.pop
        dict = SYNONYM.detect {|d| d[:synonym].include? new_value}
        if dict
          result = dict[:word]
          break
        end
      end
    end

    result
  end
end