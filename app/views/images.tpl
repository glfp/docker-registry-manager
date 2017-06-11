{{template "base/base.html" .}}
{{define "body"}}
{{template "modal.tpl" .}}
  <div class="right-content-container">
    <div class="header">
      <ol class="breadcrumb">
        <li><a href="/">Home</a></li>
        <li><a href="/registries">Registries</a></li>
        <li><a class="registry-name" href="/registries/{{.registryName}}/repositories">{{.registryName}}</a></li>
        <li><a href="/registries/{{.registryName}}/repositories">Repositories</a></li>
        <li><a class="registry-name" href="/registries/{{.registryName}}/repositories/{{.repositoryNameEncode}}/tags">{{.repositoryName}}</a></li>
        <li><a class="registry-name" href="/registries/{{.registryName}}/repositories/{{.repositoryNameEncode}}/tags">Tags</a></li>
        <li class="active">{{.tagName}}</li>
      </ol>
    </div>
    <div class="content-block white-bg">
      <div class="row" style="border-bottom:1px solid #ddd">
        <div class="col-md-4">
          <ul class="nav nav-tabs" role="tablist" style="border-bottom:none;">
            <li role="presentation" class="active"><a href="#overview" aria-controls="overview" role="tab" data-toggle="tab">Overview</a></li>
            <li role="presentation"><a href="#stages" aria-controls="stages" role="tab" data-toggle="tab">Stages</a></li>
          </ul>
        </div>
        <div class="col-md-8">
          <div id="keywords" style="float:right;">
              {{range $keyword, $keywordInfo := .labels}}
                <a class="label keyword-label {{$keywordInfo.Color}}"><i style="font-size:10px" class="fa {{$keywordInfo.Icon}}"></i> {{$keyword}}</a>
              {{end}}
          </div>
        </div>
      </div>
      <div class="row">
        <div class="tab-content">
          <div role="tabpanel" class="tab-pane active" id="overview">
            <div class="row">
              <div class="col-md-12">
                <div class="col-md-12">
                  <h4>Image Overview</h4>
                  <ul>
                    <li>Layers: {{.tag.LayerCount}}</li>
                    <li>Last Updated: {{timeAgo .tag.LastModified}}</li>
                  </ul>
                    <h4>Push/Pull this Image</h4>
                    <ul>
                      <li>docker pull {{.registryName}}/{{.repositoryName}}:{{.tagName}}</li></li>
                      <li>docker push {{.registryName}}/{{.repositoryName}}:{{.tagName}}</li></li>
                    </ul>
                </div>
              </div>
            </div>
          </div>
          <div role="tabpanel" class="tab-pane" id="stages">
            <table id="datatable" class="table" cellspacing="0" width="100%">
              <thead>
                <th>Stage</th>
                <th>Digest</th>
                <th>Command</th>
                <th>Size <i class="fa fa-question-circle" aria-hidden="true" data-toggle="tooltip" data-placement="top" title="Compressed tar.gz size"></i></th>
                <th>Created</th>
              </thead>
              <tbody>
                {{range $i, $history := $.tag.History}}
               <tr data-tag-name="">
                 <td>{{oneIndex $i}}</td>
                {{if not $history.EmptyLayer}}
                 <td data-order=""></i>{{$history.ManifestLayer.Digest}}</td>
                {{else}}
                 <td data-order="0">N/A</td>
                 {{end}}
                 <td>
                    {{range $i, $cmd := $history.Commands}}
                        <div data-keywords="{{$cmd.KeywordTags}}">{{$cmd.Cmd}}</div>
                    {{end}}
                 </td>
                {{if not $history.EmptyLayer}}
                 <td data-order="{{$history.ManifestLayer.Size}}"></i>{{bytefmt $history.ManifestLayer.Size}}</td>
                 {{else}}
                 <td data-order="0">0</td>
                 {{end}}
                 <td>{{timeAgo $history.Created}}</td>
               </tr>
               {{end}}
             </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

  </div>

  <script>
  $('#image-tabs li a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  })

  $(document).ready(function() {
      $('#datatable').DataTable({
          "order": [[ 0, "asc" ]],
          "searching": false,
          "info": false,
          "paging": false,
          "columnDefs": [
            {"orderable": false, "targets": 1},
            {"orderable": false, "targets": 2},
            {"width": "100px", "targets": 3}
          ]
      });
      $(function () {
        $('[data-toggle="tooltip"]').tooltip({container: 'body'})
      })
  });
  </script>

{{end}}
