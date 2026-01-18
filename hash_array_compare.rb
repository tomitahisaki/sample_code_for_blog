Group = Struct.new(:id, :code, :name, :description)

n = 100_000
groups = Array.new(n) { |i| Group.new(i, "code#{i}", "name#{i}", "description#{i}") }

# ===Array===
def find_in_array(groups, id, code)
  groups.find { |g| g.id == id && g.code == code }
end

# ===Hash===
INDEX = groups.index_by { |g| ["#{g.id}_#{g.code}"] }

def find_in_hash(index, id, code)
  index["#{id}_#{code}"]
end
