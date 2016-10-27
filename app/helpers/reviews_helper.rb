module ReviewsHelper

  def semantic_params(params)
    params[:comments] = true if params[:user].present?
    params.delete_if { |_, v| v == 'false' }

    sem = params.sort.map do |v|
      case v[0]
        when :user, 'user' then
          "by #{v[1]}"
        when :comments, 'comments' then
          :comments
        when :flags, 'flags' then
          :flags
        else
          ''
      end
    end

    sem.insert(1, :and) if params.key?(:flags) && params.key?(:comments)
    sem.insert(0, :with) unless sem.length < 1
    sem.join ' '
  end
end