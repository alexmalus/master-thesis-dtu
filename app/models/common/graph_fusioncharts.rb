class Common::GraphFusioncharts

  def self.make_velocity_chart(project)
  	# Velocity is the sum of the estimates of delivered (i.e., accepted) features per iteration.
  	# https://www.scrumalliance.org/community/articles/2014/february/velocity

    category= Array.new
    data_set_1 = Array.new
    data_set_2 = Array.new
    xaxisname = "Sprints"
    yaxisname = "User Stories Done"
    seriesname1 = ("Effort points")
    seriesname2 = ("Average effort") 

    sprint_no = 1
    effort_avg = 0
    project.sprints.each do |sprint|
      if sprint.is_done?
        category.append(:label => "#{sprint_no}")
        sprint_no += 1
        effort_avg += (effort_avg + sprint.done_effort) / sprint_no
        data_set_1.append(:value=> sprint.done_effort)
        data_set_2.append(:value=> effort_avg)
      end
    end
    
    categories = [{category: category}]
    
    caption = "Velocity chart"
    id = 'chart1'
    renderAt = 'chart-container1'
    dataset= [{seriesname: seriesname1, data: data_set_1},{seriesname: seriesname2, data: data_set_2}]
    
    graph_data = {
      chart: {
        caption: caption,
        exportenabled: "1",
        exportAtClientSide: "1",
        xaxisname: xaxisname,
        yaxisname: yaxisname,
        showvalues:"1",
        paletteColors: "#0075c2,#1aaf5d",
        },
      categories: categories,
      dataset: dataset

    }

    chart = Fusioncharts::Chart.new({
      :height => "80%",
      :width => "80%",
      :id => id,
      :type => 'msline',
      :renderAt => renderAt,
      :dataSource => graph_data
    })
  end

  def self.make_release_burndown_chart(project)
  	# https://www.mountaingoatsoftware.com/agile/scrum/release-burndown

    data = Array.new
    xaxisname = "Sprints"
    yaxisname = "Story points"

    project_committed_work = project.committed_work
    data_element = Hash.new
    data_element["label"] = "1"
    data_element["value"] = project_committed_work
    data << data_element

    sprint_no = 2
    
    project.sprints.each do |sprint|
      if sprint.is_done?
        data_element = Hash.new
        data_element["label"] = "#{sprint_no}"
        project_committed_work -= sprint.done_effort
        data_element["value"] = project_committed_work
        data << data_element
        sprint_no += 1
      end
    end
    
    caption = "Release Burndown chart"
    id = 'chart2'
    renderAt = 'chart-container2'
    
    graph_data = {
      chart: {
        caption: caption,
        exportenabled: "1",
        exportAtClientSide: "1",
        xaxisname: xaxisname,
        yaxisname: yaxisname,
        showvalues:"1",
        paletteColors: "#0075c2",
        },
        data: data
    }

    chart = Fusioncharts::Chart.new({
      :height => "80%",
      :width => "80%",
      :id => id,
      :type => 'line',
      :renderAt => renderAt,
      :dataSource => graph_data
    })
  end

  def self.make_sprint_burndown_chart(project)
  	# https://www.scrumalliance.org/community/articles/2013/august/burn-down-chart-%E2%80%93-an-effective-planning-and-tracki
    # TODO future:
    # http://www.methodsandtools.com/archive/scrumburndown.php
    # Used:
    # https://msdn.microsoft.com/en-us/library/ff731588.aspx

    category= Array.new
    data_set_1 = Array.new
    data_set_2 = Array.new
    data_set_3 = Array.new
    ideal_trend = Array.new
    xaxisname = "Days"
    yaxisname = "Remaining Effort"
    seriesname1 = ("In Progress")
    seriesname2 = ("To Do")
    seriesname3 = ("Velocity")

    # TODO:
    # current time = trendline 

    project.sprints.each do |sprint|
      if sprint.is_started?
        ideal_trend.append(:startvalue => sprint.committed_effort, :color=>'#000000',
          :display_value => "Ideal trend", :thickness => "2", :endvalue => 0)
        (sprint.start_date.to_i .. sprint.release_date.to_i).step(1.day) do |date|
          # The In Progress series shows how many hours remain for tasks that are marked as In Progress in a sprint.
          # The To Do series shows how many hours remain for tasks that are marked as To Do in a sprint.
          in_progress_effort = 0
          todo_effort = 0
          done_tasks = 0
          category.append(:label => "#{Time.at(date).utc.strftime("%m/%d/%Y")}")
          sprint.sprint_backlog.user_stories.each do |user_story|
            if user_story.status == "started" ||
              user_story.status == "to_be_reviewed" || user_story.status == "to_be_validated"
                in_progress_effort += user_story.effort
            elsif user_story.status == "taken"
              todo_effort += user_story.effort
            elsif user_story.status == "done"
              done_tasks += 1
            end
          end
          data_set_1.append(:value=> in_progress_effort)
          data_set_2.append(:value=> todo_effort)
          data_set_3.append(:value => done_tasks)
        end
      end
    end
    
    categories = [{category: category}]
    
    caption = "Sprint burndown chart"
    id = 'chart3'
    renderAt = 'chart-container3'
    dataset= [{seriesname: seriesname1, renderAs: "line", data: data_set_1},
      {seriesname: seriesname2, renderAs: "line", data: data_set_2},
      {seriesname: seriesname3, renderAs: "line", parentYAxis: "S", data: data_set_3}]
    trendlines= [line: ideal_trend]
    
    graph_data = {
      chart: {
        caption: caption,
        exportenabled: "1",
        exportAtClientSide: "1",
        xaxisname: xaxisname,
        yaxisname: yaxisname,
        paletteColors: "#0075c2,#1aaf5d,#f2c500",
        baseFontColor: "#333333",
        baseFont: "Helvetica Neue,Arial",
        captionFontSize: "14",
        subcaptionFontSize: "14",
        subcaptionFontBold: "0",
        showBorder: "0",
        bgColor: "#ffffff",
        showShadow: "0",
        canvasBgColor: "#ffffff",
        canvasBorderAlpha: "0",
        divlineAlpha: "100",
        divlineColor: "#999999",
        divlineThickness: "1",
        divLineIsDashed: "1",
        divLineDashLen: "1",
        divLineGapLen: "1",
        usePlotGradientColor: "0",
        showplotborder: "0",
        showXAxisLine: "1",
        xAxisLineThickness: "1",
        xAxisLineColor: "#999999",
        showAlternateHGridColor: "0",
        showAlternateVGridColor: "0",
        legendBgAlpha: "0",
        legendBorderAlpha: "0",
        legendShadow: "0",
        legendItemFontSize: "10",
        legendItemFontColor: "#666666",
        showvalues: 0
        },
      categories: categories,
      dataset: dataset,
      trendlines: trendlines
    }

    chart = Fusioncharts::Chart.new({
      :height => "80%",
      :width => "80%",
      :id => id,
      :type => 'mscombidy2d',
      :renderAt => renderAt,
      :dataSource => graph_data
    })
  end

end