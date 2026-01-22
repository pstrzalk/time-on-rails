module PaginationHelper
  def pagination_links(current_page:, total_pages:, params:)
    return if total_pages <= 1

    # Preserve existing query params
    base_params = params.permit(:project_id, :only_this_month).to_h

    pages = pagination_window(current_page, total_pages)

    content_tag(:nav, class: "flex items-center justify-center gap-1", aria: { label: "Pagination" }) do
      links = []

      # Previous link
      if current_page > 1
        links << link_to("Previous", works_path(base_params.merge(page: current_page - 1)),
          class: "px-3 py-2 text-sm text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors")
      end

      # Page numbers
      pages.each do |page|
        if page == :gap
          links << content_tag(:span, "...", class: "px-3 py-2 text-gray-500")
        elsif page == current_page
          links << content_tag(:span, page.to_s,
            class: "px-3 py-2 text-sm bg-orange-500 text-white rounded-lg font-medium")
        else
          links << link_to(page.to_s, works_path(base_params.merge(page: page)),
            class: "px-3 py-2 text-sm text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors")
        end
      end

      # Next link
      if current_page < total_pages
        links << link_to("Next", works_path(base_params.merge(page: current_page + 1)),
          class: "px-3 py-2 text-sm text-gray-400 hover:text-white hover:bg-gray-800 rounded-lg transition-colors")
      end

      safe_join(links)
    end
  end

  private

  def pagination_window(current_page, total_pages)
    # Show: 1 ... current-1 current current+1 ... last
    # For small page counts, show all pages
    return (1..total_pages).to_a if total_pages <= 7

    pages = []

    # Always show first page
    pages << 1

    # Calculate window around current page
    window_start = [ current_page - 1, 2 ].max
    window_end = [ current_page + 1, total_pages - 1 ].min

    # Add gap after first page if needed
    if window_start > 2
      pages << :gap
    elsif window_start == 2
      pages << 2
      window_start = 3
    end

    # Add window pages
    (window_start..window_end).each { |p| pages << p }

    # Add gap before last page if needed
    if window_end < total_pages - 1
      pages << :gap
    elsif window_end == total_pages - 1
      # Already included
    end

    # Always show last page
    pages << total_pages unless pages.include?(total_pages)

    pages
  end
end
