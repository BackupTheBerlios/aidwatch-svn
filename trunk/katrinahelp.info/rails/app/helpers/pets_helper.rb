module PetsHelper
  def good_print(str)
    str.empty? ? "unknown" : str.capitalize
  end
end
